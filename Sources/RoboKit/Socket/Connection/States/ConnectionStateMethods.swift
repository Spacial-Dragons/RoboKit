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
    func connectionDidFail(error: Error) async {
        if let failedConnection = failedConnection {
            failedConnection()
        }
        Task { @MainActor in
            Connection.log("Connection \(self.id) failed with error: \(error)", level: .error)
        }
        await self.stop(error: error)
    }
    /// Method that cancels the connection once it is ended.
    func connectionDidEnd() async {
        await Connection.log("Connection \(self.id) ended", level: .info)
        await self.stop(error: nil)
    }

    public func setDidStopCallback(_ callback: @escaping (Error?) -> Void) {
        self.didStopCallback = callback
    }

    public func setSetupConnection(_ handler: @escaping () -> Void) {
        self.setupConnection = handler
    }

    public func setWaitingConnection(_ handler: @escaping () -> Void) {
        self.waitingConnection = handler
    }

    public func setPreparingConnection(_ handler: @escaping () -> Void) {
        self.preparingConnection = handler
    }

    public func setReadyConnection(_ handler: @escaping () -> Void) {
        self.readyConnection = handler
    }

    public func setFailedConnection(_ handler: @escaping () -> Void) {
        self.failedConnection = handler
    }

    public func setCancelledConnection(_ handler: @escaping () -> Void) {
        self.cancelledConnection = handler
    }
}
