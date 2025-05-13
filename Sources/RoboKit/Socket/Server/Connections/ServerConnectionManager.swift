//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //


import Network

extension TCPServer {
    /// Determines what should be done when the server accepts a new connection, and
    /// assigns the individual connection methods.
    /// - Parameters:
    ///  - nwConnection: the new connection stablished with a client.
    func didAccept(nwConnection: NWConnection) {
        let connection = Connection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { [weak self] _ in
            guard let self = self else { return }
            self.connectionDidStop(connection)
        }
        connection.start(values: nil)
        connection.setupConnection = self.setupConnection
        connection.waitingConnection = self.waitingConnection
        connection.preparingConnection = self.preparingConnection
        connection.readyConnection = self.readyConnection
        connection.failedConnection = self.failedConnection
        connection.cancelledConnection = self.cancelledConnection
        Task { @MainActor in
            TCPServer.log("Server accepted new connection with ID: \(connection.id)", level: .info)
        }
    }
    /// Helper method that manages the server's dictionary of connections when the server has a connection ended.
    /// - Parameters:
    ///  - connection: the connection that was concluded.
    func connectionDidStop(_ connection: Connection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        Task { @MainActor in
            TCPServer.log("Server closed connection with ID: \(connection.id)", level: .info)
        }
    }
    /// Helper method that cancels a connection when it's cancelled or fails.
    func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            Task { @MainActor in
                TCPServer.log("Connection \(connection.id) has stopped", level: .info)
            }
        }
        self.connectionsByID.removeAll()
        Task { @MainActor in
            TCPServer.log("Server stopped", level: .info)
        }
    }
}
