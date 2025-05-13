//
//  Helper.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//
import Foundation

extension Connection {
    /// Starts the Connection between the Client and Server
    func start(values: [Int]?) {
        self.nwConnection.stateUpdateHandler = { [weak self] newState in
            guard let self = self else { return }
            self.stateDidChange(to: newState)
        }
        self.setupReceive()
        if let values = values {
            let data: [Int] = values
            let convertedData = Data(data.description.utf8)
            self.send(data: convertedData)
        }
        self.nwConnection.start(queue: .main)
        Task { @MainActor in
            Connection.log("Connection \(self.id) started", level: .info)
        }
    }
    /// Method responsible for cleaning up the Connections stateUpdateHandler and CallBack once it is ended or fails.
    /// - Parameters:
    ///  - error: In case of failure, this is the error that caused it
    func stop(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
        Task { @MainActor in
            Connection.log("Connection \(self.id) stopped", level: .info)
        }
    }
}
