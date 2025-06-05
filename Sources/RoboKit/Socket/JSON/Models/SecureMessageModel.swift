//
//  SecureMessageModel.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation

/// A secure wrapper for messages that adds authentication and integrity verification.
///
/// `SecureMessageWrapper` wraps the original `CPRMessageModel` and adds optional
/// authentication tokens and checksums for enhanced security.
public struct SecureMessageWrapper: Codable, Sendable {
    /// The original message payload
    public let payload: CPRMessageModel

    /// Optional authentication token
    public let token: String?

    /// Optional checksum for message integrity verification
    public let checksum: String?

    /// Timestamp when the message was created
    public let timestamp: Date

    /// Creates a new secure message wrapper.
    ///
    /// - Parameters:
    ///   - payload: The original message to wrap
    ///   - token: Optional authentication token
    ///   - checksum: Optional checksum for integrity verification
    public init(payload: CPRMessageModel, token: String? = nil, checksum: String? = nil) {
        self.payload = payload
        self.token = token
        self.checksum = checksum
        self.timestamp = Date()
    }

    /// Adds an authentication token to the message.
    ///
    /// - Parameter token: The authentication token to add
    /// - Returns: A new SecureMessageWrapper with the token added
    public func addToken(_ token: String) -> SecureMessageWrapper {
        return SecureMessageWrapper(payload: self.payload, token: token, checksum: self.checksum)
    }

    /// Adds a checksum to the message.
    ///
    /// - Parameter checksum: The checksum to add
    /// - Returns: A new SecureMessageWrapper with the checksum added
    public func addChecksum(_ checksum: String) -> SecureMessageWrapper {
        return SecureMessageWrapper(payload: self.payload, token: self.token, checksum: checksum)
    }
}
