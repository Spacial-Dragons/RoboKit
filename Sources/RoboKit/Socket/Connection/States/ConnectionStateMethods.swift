//
//  StateMethods.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//

extension Connection {
    /// Method that cancels the connection once it fails.
    /// - Parameters:
    ///  - error: the error that occurred to cause the failure
    func connectionDidFail(error: Error) {
        if let failedConnection = failedConnection {
            failedConnection()
        }
        Task { @MainActor in
            Connection.log("Connection \(self.id) failed with error: \(error)", level: .error)
        }
        self.stop(error: error)
    }
    /// Method that cancels the connection once it is ended.
    func connectionDidEnd() {
        Task { @MainActor in
            Connection.log("Connection \(self.id) ended", level: .info)
        }
        self.stop(error: nil)
    }
}
