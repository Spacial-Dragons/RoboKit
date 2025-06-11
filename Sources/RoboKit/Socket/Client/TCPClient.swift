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
import Network
import SwiftUI

<<<<<<< HEAD
/// The TCP Client class holds the logic for the client of our TCP connection.
public actor TCPClient {
=======
/// TCP Client that supports both TLS and non-TLS connections based on SecurityOptions configuration.
/// Generic over the message type to support any Codable & Sendable message type.
public actor TCPClient<MessageType: Codable & Sendable> {
>>>>>>> main
    /// The connection to the server
    public var connection: NWConnection?
    /// Host of the server the client should connect to
    public var host: NWEndpoint.Host
    /// Port of the server the client should connect to
    public var port: NWEndpoint.Port
<<<<<<< HEAD
=======
    /// Security configuration for TLS and authentication
    public var security: SecurityOptions
>>>>>>> main
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
<<<<<<< HEAD
=======

>>>>>>> main
    @MainActor
    func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
<<<<<<< HEAD
    /// Initializes the client and the connection instance to the server. Warning: Connection is not yet running here.
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port) async {
        self.host = host
        self.port = port
        self.connection = NWConnection(host: host, port: port, using: .tcp)
        await log("TCPClient initialized with host: \(host) and port: \(port)", level: .info)
=======

    /// Initializes the client and the connection instance to the server. Warning: Connection is not yet running here.
    /// - Parameters:
    ///   - host: The server host to connect to
    ///   - port: The server port to connect to
    ///   - security: Security configuration for TLS and authentication. Defaults to TLS enabled.
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port, security: SecurityOptions = SecurityOptions()) async {
        self.host = host
        self.port = port
        self.security = security

        // Configure network parameters based on security settings
        let parameters: NWParameters = security.useTLS
            ? NWParameters(tls: .init(), tcp: .init())
            : NWParameters.tcp

        self.connection = NWConnection(host: host, port: port, using: parameters)

        let securityType = security.useTLS ? "TLS" : "non-TLS"
        await log("TCPClient initialized with host: \(host), port: \(port), security: \(securityType)", level: .info)
    }

    /// Creates a secure message wrapper with authentication and checksum if configured.
    /// - Parameter payload: The original message payload
    /// - Returns: A SecureMessageWrapper with optional token and checksum
    public func createSecureMessage(payload: MessageType) -> SecureMessageWrapper<MessageType> {
        var message = SecureMessageWrapper(payload: payload)

        // Add authentication token if provider is configured
        if let token = security.tokenProvider?() {
            message = message.addToken(token)
        }

        // Add checksum if provider is configured
        let messageData = CodingManager.encodeToJSON(data: payload)
        if let checksum = security.checksumProvider?(messageData) {
            message = message.addChecksum(checksum)
        }

        return message
>>>>>>> main
    }
}
