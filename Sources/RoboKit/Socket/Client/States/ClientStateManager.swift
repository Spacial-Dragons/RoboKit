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
    /// Function to start the connection to the server.
    ///  The state update handler administers the possible NWConnection statuses and calls helper methods accordingly
    public func startConnection(value: Data) async {
        await log("Starting TCP connection...", level: .info)
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
                    await self.connectionReady(value: value)
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
        await self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
}
