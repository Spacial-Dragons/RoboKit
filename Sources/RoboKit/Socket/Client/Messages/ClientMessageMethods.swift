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
}
