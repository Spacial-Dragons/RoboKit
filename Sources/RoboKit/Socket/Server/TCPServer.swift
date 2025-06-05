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

/// TCP Server that supports both TLS and non-TLS connections based on SecurityOptions configuration.
public actor TCPServer {
    /// The server's connection listener.
    public let listener: NWListener
    /// Security configuration for TLS and authentication
    public let security: SecurityOptions
    /// This array and the existence of the `Connection` class allow for the connection of
    /// multiple clients to this server at once.
    var connectionsByID: [Int: Connection] = [:]
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
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

    /// Initializes the server's listener with security configuration.
    /// - Parameters:
    ///   - port: The port to listen on
    ///   - security: Security configuration for TLS and authentication. Defaults to TLS enabled.
    public init(port: UInt16, security: SecurityOptions = SecurityOptions()) async throws {
        self.security = security

        // Configure network parameters based on security settings
        let parameters: NWParameters = security.useTLS
            ? NWParameters(tls: .init(), tcp: .init())
            : NWParameters.tcp

        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try NWListener(using: parameters, on: nwPort)

        let securityType = security.useTLS ? "TLS" : "non-TLS"
        await TCPServer.log("Server initialized on port \(port) with \(securityType) security", level: .info)
    }

    /// Creates a secure message wrapper with authentication and checksum if configured.
    /// - Parameter payload: The original message payload
    /// - Returns: A SecureMessageWrapper with optional token and checksum
    private func createSecureMessage(payload: CPRMessageModel) -> SecureMessageWrapper {
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
    }
}
