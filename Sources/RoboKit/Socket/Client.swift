//
//  Client.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation
import Network
import SwiftUI

/// The TCP Client class holds the logic for the client of our TCP connection.
@Observable public final class TCPClient: @unchecked Sendable {
    /// The connection to the server
    public var connection: NWConnection?
    /// Host of the server the client should connect to
    public var host: NWEndpoint.Host
    /// Port of the server the client should connect to
    public var port: NWEndpoint.Port
    /// Custom logic for when the connection to the server is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    @MainActor
    private func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

    /// Initializes the client and the connection instance to the server. Warning: Connection is not yet running here.
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        self.host = host
        self.port = port
        self.connection = NWConnection(host: host, port: port, using: .tcp)
        Task { @MainActor in
            log("TCPClient initialized with host: \(host) and port: \(port)", level: .info)
        }
    }

    /// Function to start the connection to the server.
    ///  The state update handler administers the possible NWConnection statuses and calls helper methods accordingly
    public func startConnection(value: Data) {
        Task { @MainActor in
            log("Starting TCP connection...", level: .info)
        }
        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            Task { @MainActor in
                self.log("Client state changed to: \(state)", level: .debug)
            }
            switch state {
            case .setup:
                self.setUpConnection()
            case .waiting:
                self.connectionWaiting()
            case .preparing:
                self.connectionPreparing()
            case .ready:
                Task { @MainActor in
                    self.log("Client connection ready", level: .info)
                }
                self.connectionReady(value: value)
            case .failed:
                self.connectionFailed()
            case .cancelled:
                self.connectionCanceled()
            default:
                Task { @MainActor in
                    self.log("Client state: unknown", level: .debug)
                }
            }
        }
        self.receiveMessage()
        self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
    /// Receives messages sent from the server to the client
    /// - Parameters:
    ///   - minLength: The minimum length in bytes to receive from the connection, until the
    ///   content is complete. If unassigned, it will be set to 1
    ///   - maxLength: The maximum length to receive from the connection at once.
    ///   If unassigned, it will be set to 65536 bytes
    public func receiveMessage(minLength min: Int = 1, maxLength max: Int = 65536) {
        self.connection?.receive(minimumIncompleteLength: min, maximumLength: max) { data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                Task { @MainActor in
                    self.log("Client received data: \(String(data: data, encoding: .utf8) ?? "error")", level: .debug)
                }
            }

            if isComplete {
                self.connectionEnded()
            } else if let error = error {
                Task { @MainActor in
                    self.log("Error receiving message: \(error)", level: .error)
                }

            } else {
                self.receiveMessage()
            }
        }
    }
    /// Ends the connection to the server
    public func connectionEnded() {
        Task { @MainActor in
            log("Client connection ended", level: .info)
        }
        self.connection?.cancel()
    }
    /// Sends message from the client to the designated server. A connection must be established
    /// and running before this is called
    /// - Parameters:
    ///    - data: the data that should be sent to the server
    public func sendMessage(data: Data) {
        Task { @MainActor in
            log("Client attempting to send data", level: .debug)
        }
        self.connection?.send(content: data, completion: .contentProcessed({ [weak self] error in
            guard let self = self else { return }
            if error != nil {
                Task { @MainActor in
                    self.log("Client failed to send data", level: .error)
                }
                self.connectionFailed()
                return
            }
            Task { @MainActor in
                self.log("Client sent data: \(String(data: data, encoding: .utf8) ?? "error")", level: .debug)
            }
        }))
    }
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
}
