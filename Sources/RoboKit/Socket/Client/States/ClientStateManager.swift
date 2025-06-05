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
    /// Function to start the connection to the server with a CPRMessageModel.
    /// The state update handler administers the possible NWConnection statuses and calls helper methods accordingly.
    /// This is the recommended method as it automatically uses TLS security features when configured.
    /// - Parameter message: The initial CPRMessageModel to send once connection is ready
    public func startConnection(with message: CPRMessageModel) async {
        let connectionType = security.useTLS ? "TLS" : "TCP"
        await log("Starting \(connectionType) connection...", level: .info)

        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            Task {
                await self.log("Client state changed to: \(state)", level: .debug)
                switch state {
                case .setup:
                    await self.setUpConnection()
                case .waiting:
                    await self.connectionWaiting()
                case .preparing:
                    await self.connectionPreparing()
                case .ready:
                    await self.log("Client connection ready", level: .info)
                    await self.connectionReady(message: message)
                case .failed:
                    await self.connectionFailed()
                case .cancelled:
                    await self.connectionCanceled()
                default:
                    await self.log("Client state: unknown", level: .debug)
                }
            }
        }
        await self.receiveMessage()
        self.connection?.start(queue: .main)
    }

    /// Function to start the connection to the server with raw data.
    /// The state update handler administers the possible NWConnection statuses and calls helper methods accordingly.
    /// Consider using startConnection(with:) for CPRMessageModel to leverage TLS security features.
    /// - Parameter data: The initial raw data to send once connection is ready
    public func startConnection(value data: Data) async {
        let connectionType = security.useTLS ? "TLS" : "TCP"
        await log("Starting \(connectionType) connection with raw data...", level: .info)

        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            Task {
                await self.log("Client state changed to: \(state)", level: .debug)
                switch state {
                case .setup:
                    await self.setUpConnection()
                case .waiting:
                    await self.connectionWaiting()
                case .preparing:
                    await self.connectionPreparing()
                case .ready:
                    await self.log("Client connection ready", level: .info)
                    await self.connectionReady(data: data)
                case .failed:
                    await self.connectionFailed()
                case .cancelled:
                    await self.connectionCanceled()
                default:
                    await self.log("Client state: unknown", level: .debug)
                }
            }
        }
        await self.receiveMessage()
        self.connection?.start(queue: .main)
    }

    /// Convenience method to start connection without sending initial data
    public func startConnection() async {
        let connectionType = security.useTLS ? "TLS" : "TCP"
        await log("Starting \(connectionType) connection without initial data...", level: .info)

        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            Task {
                await self.log("Client state changed to: \(state)", level: .debug)
                switch state {
                case .setup:
                    await self.setUpConnection()
                case .waiting:
                    await self.connectionWaiting()
                case .preparing:
                    await self.connectionPreparing()
                case .ready:
                    await self.log("Client connection ready", level: .info)
                    await self.connectionReady()
                case .failed:
                    await self.connectionFailed()
                case .cancelled:
                    await self.connectionCanceled()
                default:
                    await self.log("Client state: unknown", level: .debug)
                }
            }
        }
        await self.receiveMessage()
        self.connection?.start(queue: .main)
    }
}
