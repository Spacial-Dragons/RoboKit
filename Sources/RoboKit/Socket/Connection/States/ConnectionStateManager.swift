//
//  StateManager.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//
import Network

extension Connection {
    // swiftlint:disable cyclomatic_complexity
    /// Function to handle the connections states.
    /// The state update handler administers the possible NWConnection statuses
    /// and calls helper methods accordingly
    func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .setup:
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: setup", level: .debug)
            }
            if let setupConnection = setupConnection {
                setupConnection()
            }
        case .waiting(let error):
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: waiting with error: \(error)", level: .warning)
            }
            if let waitingConnection = waitingConnection {
                waitingConnection()
            }
            self.connectionDidFail(error: error)
        case .preparing:
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: preparing", level: .debug)
            }
            if let preparingConnection = preparingConnection {
                preparingConnection()
            }
        case .ready:
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: ready", level: .info)
            }
            if let readyConnection = readyConnection {
                readyConnection()
            }
        case .failed(let error):
            self.connectionDidFail(error: error)
        case .cancelled:
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: cancelled", level: .warning)
            }
            if let cancelledConnection = cancelledConnection {
                cancelledConnection()
            }
        default:
            Task { @MainActor in
                Connection.log("Connection \(self.id) state: unknown", level: .debug)
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
