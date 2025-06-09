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
import Network

extension TCPServer {
    /// The state handler for the server.
    public func stateDidChange(to newState: NWListener.State) async {
        switch newState {
        case .setup:
            await TCPServer.log("Server state: setup", level: .debug)
        case .waiting:
            await TCPServer.log("Server state: waiting", level: .debug)
        case .ready:
            await TCPServer.log("Server state: ready", level: .info)
        case .failed(let error):
            await TCPServer.log("Server failed with error: \(error)", level: .error)
            await self.stop()
        case .cancelled:
            await TCPServer.log("Server state: cancelled", level: .warning)
        default:
            await TCPServer.log("Server state: unknown", level: .debug)
        }
    }
}
