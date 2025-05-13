//
//  StateMethods.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//
import Foundation

extension Connection {
    /// Sends data from the server to the client
    /// - Parameters:
    ///  - data: The data that should be sent
    func send(data: Data) {
        self.nwConnection.send(content: data, completion: .contentProcessed { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            Task { @MainActor in
                Connection.log("Connection \(self.id) sent data: \(data as NSData)", level: .debug)
            }
        })
    }
    /// Method responsible for receiving and decoding messages from clients.
    public func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            guard let data = data else { return }
            do {
                let message: CPRMessageModel = try CodingManager.decodeFromJSON(data: data)
                if type(of: message) == CPRMessageModel.self {
                    Task { @MainActor in
                        Connection.log(
                            """
                            Connection \(self.id) received JSON message:
                            [Claw Control: \(message.clawControl),
                             Position & Rotation: \(message.positionAndRotation)]
                            """,
                            level: .debug)
                    }
                }

            } catch {
                Task { @MainActor in
                    Connection.log("Connection \(self.id) failed to decode message: \(error)", level: .error)
                }
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }
}
