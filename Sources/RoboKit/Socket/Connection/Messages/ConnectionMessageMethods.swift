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

extension Connection {
    /// Sends data from the server to the client
    /// - Parameters:
    ///  - data: The data that should be sent
    public func send(data: Data) async {
        self.nwConnection.send(content: data, completion: .contentProcessed { [weak self] error in
            guard let self = self else { return }
            Task {
                if let error = error {
                    await self.connectionDidFail(error: error)
                    return
                }
                await Connection.log("Connection \(self.id) sent data: \(data as NSData)", level: .debug)
            }
        })
    }

    /// Sends a message using the appropriate security level
    /// - Parameters:
    ///   - message: The message to send
    ///   - security: Security configuration to use
    public func sendMessage(_ message: MessageType, security: SecurityOptions) async {
        if security.useTLS && (security.tokenProvider != nil || security.checksumProvider != nil) {
            await Connection.log("Connection \(self.id) sending message with security features", level: .debug)
            await sendSecureMessage(payload: message, security: security)
        } else {
            await Connection.log("Connection \(self.id) sending message as plain JSON", level: .debug)
            let data = CodingManager.encodeToJSON(data: message)
            await send(data: data)
        }
    }

    /// Method responsible for receiving and decoding messages from clients.
    /// Supports both secure and regular message formats for backward compatibility.
    public func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            guard let data = data else { return }
            Task {
<<<<<<< HEAD
                do {
                    let message: CPRMessageModel = try CodingManager.decodeFromJSON(data: data)
                    if type(of: message) == CPRMessageModel.self {
                        await Connection.log(
                            """
                            Connection \(self.id) received JSON message:
                            [Claw Control: \(message.clawControl),
                             Position & Rotation: \(message.positionAndRotation),
                            Object Width: \(message.width)]
                            """,
                            level: .debug)
                    }
                    await self.updateLatestMessage(message: message)
                } catch {
                    await Connection.log("Connection \(self.id) failed to decode message: \(error)", level: .error)
                }
=======
                await self.processReceivedData(data)
>>>>>>> main
                if isComplete {
                    await self.connectionDidEnd()
                } else if let error = error {
                    await self.connectionDidFail(error: error)
                } else {
                    await self.setupReceive()
                }
            }
        }
    }

    /// Processes received data and attempts to decode secure or regular messages
    /// - Parameter data: The received data to process
    public func processReceivedData(_ data: Data) async {
        do {
            // Try to decode as secure message first
            let secureMessage: SecureMessageWrapper<MessageType> = try CodingManager.decodeFromJSON(data: data)
            await Connection.log(
                """
                Connection \(self.id) received secure message:
                [Token: \(secureMessage.token?.prefix(10) ?? "none")...,
                 Checksum: \(secureMessage.checksum?.prefix(10) ?? "none")...,
                 Payload: \(secureMessage.payload)]
                """,
                level: .debug
            )

            self.updateLatestMessage(message: secureMessage.payload)
        } catch {
            // Fallback to regular message decoding for backward compatibility
            do {
                let message: MessageType = try CodingManager.decodeFromJSON(data: data)
                await Connection.log(
                    """
                    Connection \(self.id) received JSON message:
                    [Payload: \(message)]
                    """,
                    level: .debug
                )
                self.updateLatestMessage(message: message)
            } catch {
                await Connection.log("Connection \(self.id) failed to decode message: \(error)", level: .error)
            }
        }
    }
}
