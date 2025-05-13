//
//  StateMethods.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//

import Foundation

extension TCPClient {
    /// Adds message to the server log, equates the `stateUpdateHandler` to nil and cancels
    /// the NWConnection. Called when the State Handler is on "cancelled"
    public func connectionFailed() {
        Task { @MainActor in
            log("Client connection failed", level: .error)
        }
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
    public func connectionWaiting() {
        Task { @MainActor in
            log("Client connection waiting", level: .warning)
        }
        if let waiting = waitingConnection {
            waiting()
        }
    }

    /// Determines the logic that should be implemented when the State Handler is in `preparing`
    public func connectionPreparing() {
        Task { @MainActor in
            log("Client connection preparing", level: .debug)
        }
        if let preparing = preparingConnection {
            preparing()
        }
    }
    /// Determines the logic that should be implemented when the State Handler is in `ready`.
    /// This is where the main connection logic should be implemented
    /// - Parameters:
    ///   - value: the value that will be sent to the server as soon as the connection starts
    public func connectionReady(value: Data) {
        Task { @MainActor in
            log("Client connection ready", level: .info)
        }
        if let ready = readyConnection {
            ready()
        }
    }
    /// Determines the logic that should be implemented when the State Handler is in `cancelled`
    public func connectionCanceled() {
        Task { @MainActor in
            log("Client connection cancelled", level: .warning)
        }
        if let canceled = cancelledConnection {
            canceled()
        }
    }
    /// Ends the connection to the server
    public func connectionEnded() {
        Task { @MainActor in
            log("Client connection ended", level: .info)
        }
        self.connection?.cancel()
    }
}
