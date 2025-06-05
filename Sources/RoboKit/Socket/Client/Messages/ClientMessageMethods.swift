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
    /// Receives messages sent from the server to the client
    /// - Parameters:
    ///   - minLength: The minimum length in bytes to receive from the connection, until the
    ///   content is complete. If unassigned, it will be set to 1
    ///   - maxLength: The maximum length to receive from the connection at once.
    ///   If unassigned, it will be set to 65536 bytes
    public func receiveMessage(minLength min: Int = 1, maxLength max: Int = 65536) async {
        self.connection?.receive(minimumIncompleteLength: min, maximumLength: max) { data, _, isComplete, error in
            Task {
                if let data = data, !data.isEmpty {
                    await self.processReceivedData(data)
                }
                if isComplete {
                    await self.connectionEnded()
                } else if let error = error {
                    await self.log("Error receiving message: \(error)", level: .error)
                } else {
                    await self.receiveMessage()
                }
            }
        }
    }

    /// Processes received data and attempts to decode secure messages
    /// - Parameter data: The received data to process
    private func processReceivedData(_ data: Data) async {
        do {
            // Try to decode as secure message first
            let secureMessage: SecureMessageWrapper = try CodingManager.decodeFromJSON(data: data)
            await self.log(
                """
                Client received secure message:
                [Token: \(secureMessage.token?.prefix(10) ?? "none")...,
                 Checksum: \(secureMessage.checksum?.prefix(10) ?? "none")...,
                 Payload: \(secureMessage.payload)]
                """,
                level: .debug
            )

            // Verify checksum if configured
            if let checksum = secureMessage.checksum,
               let checksumProvider = security.checksumProvider {
                let payloadData = CodingManager.encodeToJSON(data: secureMessage.payload)
                let expectedChecksum = checksumProvider(payloadData)
                if checksum != expectedChecksum {
                    await self.log("Checksum verification failed", level: .warning)
                }
            }
        } catch {
            // Fallback to regular message decoding
            do {
                let message: CPRMessageModel = try CodingManager.decodeFromJSON(data: data)
                await self.log("Client received regular message: \(message)", level: .debug)
            } catch {
                await self.log("Client failed to decode message: \(error)", level: .error)
            }
        }
    }

    /// Sends a CPRMessageModel message from the client to the designated server. A connection must be established
    /// and running before this is called. Automatically uses secure messaging if TLS is enabled.
    /// This is the recommended method for sending robot control messages.
    /// - Parameter message: The CPRMessageModel to send
    public func sendMessage(_ message: CPRMessageModel) async {
        if security.useTLS && (security.tokenProvider != nil || security.checksumProvider != nil) {
            await log("Sending CPRMessageModel with TLS security features", level: .debug)
            // Create secure message and send directly
            let secureMessage = createSecureMessage(payload: message)
            let data = CodingManager.encodeToJSON(data: secureMessage)
            await sendRawData(data)
        } else if security.useTLS {
            await log("Sending CPRMessageModel over TLS without additional security features", level: .debug)
            let data = CodingManager.encodeToJSON(data: message)
            await sendRawData(data)
        } else {
            await log("Sending CPRMessageModel as JSON over non-TLS connection", level: .debug)
            let data = CodingManager.encodeToJSON(data: message)
            await sendRawData(data)
        }
    }
    /// Sends a secure message from the client to the designated server. A connection must be established
    /// and running before this is called. This method explicitly creates a secure wrapper.
    /// - Parameter payload: The CPRMessageModel payload to send
    public func sendSecureMessage(payload: CPRMessageModel) async {
        await log("Explicitly sending secure message", level: .debug)
        let secureMessage = createSecureMessage(payload: payload)
        let data = CodingManager.encodeToJSON(data: secureMessage)
        await sendRawData(data)
    }

    /// Sends raw data from the client to the designated server. A connection must be established
    /// and running before this is called. This is the base method that actually performs the network send.
    /// - Parameter data: The raw data to send
    public func sendRawData(_ data: Data) async {
        await log("Client sending raw data (\(data.count) bytes)", level: .debug)
        self.connection?.send(content: data, completion: .contentProcessed({ [weak self] error in
            guard let self = self else { return }
            Task {
                if let error = error {
                    await self.log("Client failed to send raw data: \(error)", level: .error)
                    await self.connectionFailed()
                    return
                }
                await self.log("Client successfully sent \(data.count) bytes", level: .debug)
            }
        }))
    }
}
