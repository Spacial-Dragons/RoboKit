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
    func stateDidChange(to state: NWConnection.State) async {
        switch state {
        case .setup:
            await Connection.log("Connection \(self.id) state: setup", level: .debug)
            if let setupConnection = setupConnection {
                setupConnection()
            }
        case .waiting(let error):
            await Connection.log("Connection \(self.id) state: waiting with error: \(error)", level: .warning)
            if let waitingConnection = waitingConnection {
                waitingConnection()
            }
            await self.connectionDidFail(error: error)
        case .preparing:
            await Connection.log("Connection \(self.id) state: preparing", level: .debug)
            if let preparingConnection = preparingConnection {
                preparingConnection()
            }
        case .ready:
            await Connection.log("Connection \(self.id) state: ready", level: .info)
            if let readyConnection = readyConnection {
                readyConnection()
            }
        case .failed(let error):
            await self.connectionDidFail(error: error)
        case .cancelled:
            await Connection.log("Connection \(self.id) state: cancelled", level: .warning)
            if let cancelledConnection = cancelledConnection {
                cancelledConnection()
            }
        default:
            await Connection.log("Connection \(self.id) state: unknown", level: .debug)
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
