//
//  StateManager.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//
import Foundation

extension TCPClient {
    /// Function to start the connection to the server.
    ///  The state update handler administers the possible NWConnection statuses and calls helper methods accordingly
    public func startConnection(value: Data) {
        Task { @MainActor in
            log("Starting TCP connection...", level: .info)
        }
        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            Task { @MainActor in
                self.log("Client state changed to: \(state)", level: .debug)
            }
            switch state {
            case .setup:
                self.setUpConnection()
            case .waiting:
                self.connectionWaiting()
            case .preparing:
                self.connectionPreparing()
            case .ready:
                Task { @MainActor in
                    self.log("Client connection ready", level: .info)
                }
                self.connectionReady(value: value)
            case .failed:
                self.connectionFailed()
            case .cancelled:
                self.connectionCanceled()
            default:
                Task { @MainActor in
                    self.log("Client state: unknown", level: .debug)
                }
            }
        }
        self.receiveMessage()
        self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
}
