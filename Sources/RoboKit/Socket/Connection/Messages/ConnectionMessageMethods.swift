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
    func send(data: Data) async {
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
    /// Method responsible for receiving and decoding messages from clients.
    public func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            guard let data = data else { return }
            Task {
                do {
                    let message: CPRMessageModel = try CodingManager.decodeFromJSON(data: data)
                    if type(of: message) == CPRMessageModel.self {
                        await Connection.log(
                            """
                            Connection \(self.id) received JSON message:
                            [Claw Control: \(message.clawControl),
                             Position & Rotation: \(message.positionAndRotation)]
                            """,
                            level: .debug)
                    }
                    await self.updateLatestMessage(message: message)
                } catch {
                    await Connection.log("Connection \(self.id) failed to decode message: \(error)", level: .error)
                }
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
}
