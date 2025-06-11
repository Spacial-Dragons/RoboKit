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

import Foundation

extension TCPClient {
    /// Adds message to the server log, equates the `stateUpdateHandler` to nil and cancels
    /// the NWConnection. Called when the State Handler is on "cancelled"
    public func connectionFailed() async {
        await log("Client connection failed", level: .error)
        self.connection?.stateUpdateHandler = nil
        self.connection?.cancel()
    }
    /// Determines what should be executed during the setup of the connection.
    public func setUpConnection() {
        if let setup = setupConnection {
            setup()
        }
    }
    /// Determines the logic that should be implemented when the State Handler is in `waiting`
    public func connectionWaiting() async {
        await log("Client connection waiting", level: .warning)
        if let waiting = waitingConnection {
            waiting()
        }
    }

    /// Determines the logic that should be implemented when the State Handler is in `preparing`
    public func connectionPreparing() async {
        await log("Client connection preparing", level: .debug)
        if let preparing = preparingConnection {
            preparing()
        }
    }
    /// Determines the logic that should be implemented when the State Handler is in `ready`.
    /// This is where the main connection logic should be implemented
    /// - Parameter message: The CPRMessageModel to send once connection is ready (uses TLS security features)
    public func connectionReady(message: MessageType) async {
        await log("Client connection ready - sending initial message", level: .info)
        await sendMessage(message)
    }

    /// Determines the logic that should be implemented when the State Handler is in `ready`.
    /// This is where the main connection logic should be implemented
    /// - Parameter data: The raw data to send once connection is ready
    public func connectionReady(data: Data) async {
        await log("Client connection ready - sending initial raw data", level: .info)
        if let ready = readyConnection {
            ready()
        }
        await sendRawData(data)
    }

    /// Determines the logic that should be implemented when the State Handler is in `ready`.
    /// This is where the main connection logic should be implemented (no initial data to send)
    public func connectionReady() async {
        await log("Client connection ready - no initial data to send", level: .info)
        if let ready = readyConnection {
            ready()
        }
    }
    /// Determines the logic that should be implemented when the State Handler is in `cancelled`
    public func connectionCanceled() async {
        await log("Client connection cancelled", level: .warning)
        if let canceled = cancelledConnection {
            canceled()
        }
    }
    /// Ends the connection to the server
    public func connectionEnded() async {
        await log("Client connection ended", level: .info)
        self.connection?.cancel()
    }

    public func setSetupConnection(_ handler: @escaping () -> Void) {
        self.setupConnection = handler
    }

    public func setWaitingConnection(_ handler: @escaping () -> Void) {
        self.waitingConnection = handler
    }

    public func setPreparingConnection(_ handler: @escaping () -> Void) {
        self.preparingConnection = handler
    }

    public func setReadyConnection(_ handler: @escaping () -> Void) {
        self.readyConnection = handler
    }

    public func setFailedConnection(_ handler: @escaping () -> Void) {
        self.failedConnection = handler
    }

    public func setCancelledConnection(_ handler: @escaping () -> Void) {
        self.cancelledConnection = handler
    }
}
