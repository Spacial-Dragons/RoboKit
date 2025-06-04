//
//  Helper.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 13/05/25.
//

extension TCPServer {
    /// Starts the server. After this function is called, server is ready to receive connection requests from clients.
    public func start(logMessage: String? = "") async throws {
        if let message = logMessage {
            await TCPServer.log("Server starting: \(message)", level: .info)
        }
        self.listener.stateUpdateHandler = { [weak self] newState in
            Task { await self?.stateDidChange(to: newState) }
        }
        self.listener.newConnectionHandler = { [weak self] nwConnection in
            Task { await self?.didAccept(nwConnection: Connection(nwConnection: nwConnection)) }
        }
        self.listener.start(queue: .main)
        await TCPServer.log("Server started successfully", level: .info)
    }
}
