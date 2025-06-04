//
//  MessageManager.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 13/05/25.
//
import Network

extension TCPServer {
    /// Determines what should be done when the server accepts a new connection, and
    /// assigns the individual connection methods.
    /// - Parameters:
    ///  - nwConnection: the new connection stablished with a client.
    func didAccept(nwConnection: Connection) async {
        let connection = nwConnection
        self.connectionsByID[connection.id] = connection
        await connection.start(values: nil)
        await TCPServer.log("Server accepted new connection with ID: \(connection.id)", level: .info)
    }
    /// Helper method that manages the server's dictionary of connections when the server has a connection ended.
    /// - Parameters:
    ///  - connection: the connection that was concluded.
    func connectionDidStop(_ connection: Connection) async {
        self.connectionsByID.removeValue(forKey: connection.id)
        await TCPServer.log("Server closed connection with ID: \(connection.id)", level: .info)
    }
    /// Helper method that cancels a connection when it's cancelled or fails.
    func stop() async {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            await connection.setDidStopCallback {_ in }
            await TCPServer.log("Connection \(connection.id) has stopped", level: .info)
        }
        self.connectionsByID.removeAll()
        await TCPServer.log("Server stopped", level: .info)
    }
}
