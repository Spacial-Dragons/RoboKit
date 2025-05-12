//
//  Server.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation
import Network
import SwiftUI

@Observable public final class TCPServer: @unchecked Sendable {
    /// The server's conenction listener.
    public let listener: NWListener
    /// This array and the existence of the `Connection` class allow for the connection of
    /// multiple clients to this server at once.
    private var connectionsByID: [Int: Connection] = [:]
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    /// Initializes the server's listener. Server is NOT yet ready for
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    public init(port: UInt16) throws {
        let parameters = NWParameters.tcp
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try NWListener(using: parameters, on: nwPort)
        Task { @MainActor in
            TCPServer.log("Server initialized on port \(port)", level: .info)
        }
    }
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
    /// The state handler for the server.
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .setup:
            Task { @MainActor in
                TCPServer.log("Server state: setup", level: .debug)
            }
        case .waiting:
            Task { @MainActor in
                TCPServer.log("Server state: waiting", level: .debug)
            }
        case .ready:
            Task { @MainActor in
                TCPServer.log("Server state: ready", level: .info)
            }
        case .failed(let error):
            Task { @MainActor in
                TCPServer.log("Server failed with error: \(error)", level: .error)
            }
            self.stop()
        case .cancelled:
            Task { @MainActor in
                TCPServer.log("Server state: cancelled", level: .warning)
            }
        default:
            Task { @MainActor in
                TCPServer.log("Server state: unknown", level: .debug)
            }
        }
    }
    /// Determines what should be done when the server accepts a new connection, and
    /// assigns the individual connection methods.
    /// - Parameters:
    ///  - nwConnection: the new connection stablished with a client.
    private func didAccept(nwConnection: NWConnection) {
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
    private func connectionDidStop(_ connection: Connection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        Task { @MainActor in
            TCPServer.log("Server closed connection with ID: \(connection.id)", level: .info)
        }
    }
    /// Helper method that cancels a connection when it's cancelled or fails.
    private func stop() {
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
