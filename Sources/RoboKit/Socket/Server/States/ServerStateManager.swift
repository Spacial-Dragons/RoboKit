//
//  StateManager.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 13/05/25.
//
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
