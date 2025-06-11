//
//  SecurityOptions.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation

/// Configuration options for socket security features.
///
/// `SecurityOptions` allows developers to configure TLS encryption, authentication tokens,
/// and message checksums for secure communication. By default, TLS is enabled for security,
/// but can be disabled for compatibility with non-TLS servers.
///
/// ```swift
/// let security = SecurityOptions(useTLS: true)
/// let client = TCPClient(host: "192.168.1.100", port: 8443, security: security)
/// ```
public struct SecurityOptions: Sendable {
    /// Whether to use TLS encryption for the connection.
    /// Defaults to `true` for secure communication.
    public var useTLS: Bool

    /// Optional closure to provide authentication tokens for outgoing messages.
    /// Called before each message is sent to attach authentication credentials.
    public var tokenProvider: (@Sendable () -> String)?

    /// Optional closure to generate checksums for message integrity verification.
    /// Called with message data to generate a checksum that can be verified by the receiver.
    public var checksumProvider: (@Sendable (Data) -> String)?

    /// Creates a new SecurityOptions configuration.
    ///
    /// - Parameters:
    ///   - useTLS: Whether to enable TLS encryption. Defaults to `true`.
    ///   - tokenProvider: Optional closure to provide authentication tokens.
    ///   - checksumProvider: Optional closure to generate message checksums.
    public init(
        useTLS: Bool = true,
        tokenProvider: (@Sendable () -> String)? = nil,
        checksumProvider: (@Sendable (Data) -> String)? = nil
    ) {
        self.useTLS = useTLS
        self.tokenProvider = tokenProvider
        self.checksumProvider = checksumProvider
    }
}
