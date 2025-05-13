//
//  Helper.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 13/05/25.
//

extension TCPServer {
    /// Starts the server. After this function is called, server is ready to receive connection requests from clients.
    public func start(logMessage: String?) throws {
        if let message = logMessage {
            Task { @MainActor in
                TCPServer.log("Server starting: \(message)", level: .info)
            }
        }
        self.listener.stateUpdateHandler = self.stateDidChange(to:)
        self.listener.newConnectionHandler = self.didAccept(nwConnection:)
        self.listener.start(queue: .main)
        Task { @MainActor in
            TCPServer.log("Server started successfully", level: .info)
        }
    }
}
