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
