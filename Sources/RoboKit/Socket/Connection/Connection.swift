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

/// Global ID generator for connections to avoid static stored properties in generic types
private actor ConnectionIDGenerator {
    private var nextID: Int = 0
    
    func generateID() -> Int {
        let id = nextID
        nextID += 1
        return id
    }
}

/// Global instance of the ID generator
private let connectionIDGenerator = ConnectionIDGenerator()

/// The `Connection` class is responsible for representing each client connection to the server.
/// It handles the logic for said connections and allows for RoboKit's server to receive
/// multiple clients simultaneously. Generic over the message type to support any Codable & Sendable message type.
public actor Connection<MessageType: Codable & Sendable> {
    public let nwConnection: NWConnection
    /// The unique identification to a connection. Assigned based on the global ID generator
    let id: Int
    /// Callback for when the connection stops - marked as nonisolated so it can be set from outside the actor
    nonisolated(unsafe) var didStopCallback: ((Error?) -> Void)?
    /// Custom logic for when the connection to the client is on `setup` state
    nonisolated(unsafe) public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `waiting` state
    nonisolated(unsafe) public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `preparing` state
    nonisolated(unsafe) public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `ready` state
    nonisolated(unsafe) public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `failed` state
    nonisolated(unsafe) public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `cancelled` state
    nonisolated(unsafe) public var cancelledConnection: (() -> Void)?
    /// Latest message received by the connection
    public var latestMessage: MessageType?

    /// Initializes the Connection instance, assigning it an Integer ID
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

    init(nwConnection: NWConnection) async {
        self.nwConnection = nwConnection
        self.id = await connectionIDGenerator.generateID()
        await Connection.log("New connection created with ID: \(self.id)", level: .debug)
    }

    /// Updates the latest message received
    func updateLatestMessage(message: MessageType) {
        self.latestMessage = message
    }

    /// Creates a secure message wrapper with authentication and checksum if configured.
    /// - Parameters:
    ///   - payload: The original message payload
    ///   - security: Security configuration for authentication and checksum
    /// - Returns: A SecureMessageWrapper with optional token and checksum
    func createSecureMessage(payload: MessageType, security: SecurityOptions) -> SecureMessageWrapper<MessageType> {
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

    /// Sends a secure message to the connected client with optional authentication and checksum
    /// - Parameters:
    ///   - payload: The message payload to send
    ///   - security: Security configuration for authentication and checksum
    func sendSecureMessage(payload: MessageType, security: SecurityOptions) async {
        let secureMessage = createSecureMessage(payload: payload, security: security)
        let data = CodingManager.encodeToJSON(data: secureMessage)
        await send(data: data)
    }
}
