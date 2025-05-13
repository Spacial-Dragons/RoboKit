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
    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .setup:
            Task { @MainActor in
                TCPServer.log("Server state: setup", level: .debug)
            }
        case .waiting:
            Task { @MainActor in
                TCPServer.log("Server state: waiting", level: .debug)
            }
        case .ready:
            Task { @MainActor in
                TCPServer.log("Server state: ready", level: .info)
            }
        case .failed(let error):
            Task { @MainActor in
                TCPServer.log("Server failed with error: \(error)", level: .error)
            }
            self.stop()
        case .cancelled:
            Task { @MainActor in
                TCPServer.log("Server state: cancelled", level: .warning)
            }
        default:
            Task { @MainActor in
                TCPServer.log("Server state: unknown", level: .debug)
            }
        }
    }
}
