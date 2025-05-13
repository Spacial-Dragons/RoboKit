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
