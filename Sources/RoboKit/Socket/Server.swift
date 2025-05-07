//
//  Server.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation
import Network
import SwiftUI

@Observable public final class Server: @unchecked Sendable {
    /// The server's conenction listener.
    public let listener: NWListener
    /// This array and the existence of the `Connection` class allow for the connection of
    /// multiple clients to this server at once.
    private var connectionsByID: [Int: Connection] = [:]
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    /// Initializes the server's listener. Server is NOT yet ready for
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    public init(port: UInt16) throws {
        let parameters = NWParameters.tcp
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try NWListener(using: parameters, on: nwPort)
        Task { @MainActor in
            Server.log("Server initialized on port \(port)", level: .info)
        }
    }
    /// Starts the server. After this function is called, server is ready to receive connection requests from clients.
    public func start(logMessage: String?) throws {
        if let message = logMessage {
            Task { @MainActor in
                Server.log("Server starting: \(message)", level: .info)
            }
        }
        self.listener.stateUpdateHandler = self.stateDidChange(to:)
        self.listener.newConnectionHandler = self.didAccept(nwConnection:)
        self.listener.start(queue: .main)
        Task { @MainActor in
            Server.log("Server started successfully", level: .info)
        }
    }
    /// The state handler for the server.
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .setup:
            Task { @MainActor in
                Server.log("Server state: setup", level: .debug)
            }
        case .waiting:
            Task { @MainActor in
                Server.log("Server state: waiting", level: .debug)
            }
        case .ready:
            Task { @MainActor in
                Server.log("Server state: ready", level: .info)
            }
        case .failed(let error):
            Task { @MainActor in
                Server.log("Server failed with error: \(error)", level: .error)
            }
            self.stop()
        case .cancelled:
            Task { @MainActor in
                Server.log("Server state: cancelled", level: .warning)
            }
        default:
            Task { @MainActor in
                Server.log("Server state: unknown", level: .debug)
            }
        }
    }
    /// Determines what should be done when the server accepts a new connection, and
    /// assigns the individual connection methods.
    /// - Parameters:
    ///  - nwConnection: the new connection stablished with a client.
    private func didAccept(nwConnection: NWConnection) {
        let connection = Connection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { [weak self] _ in
            guard let self = self else { return }
            self.connectionDidStop(connection)
        }
        connection.start(values: nil)
        connection.setupConnection = self.setupConnection
        connection.waitingConnection = self.waitingConnection
        connection.preparingConnection = self.preparingConnection
        connection.readyConnection = self.readyConnection
        connection.failedConnection = self.failedConnection
        connection.cancelledConnection = self.cancelledConnection
        Task { @MainActor in
            Server.log("Server accepted new connection with ID: \(connection.id)", level: .info)
        }
    }
    /// Helper method that manages the server's dictionary of connections when the server has a connection ended.
    /// - Parameters:
    ///  - connection: the connection that was concluded.
    private func connectionDidStop(_ connection: Connection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        Task { @MainActor in
            Server.log("Server closed connection with ID: \(connection.id)", level: .info)
        }
    }
    /// Helper method that cancels a connection when it's cancelled or fails.
    private func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            Task { @MainActor in
                Server.log("Connection \(connection.id) has stopped", level: .info)
            }
        }
        self.connectionsByID.removeAll()
        Task { @MainActor in
            Server.log("Server stopped", level: .info)
        }
    }
}

/// The `Connection` class is responsible for representing each client connection to the server.
/// It handles the logic for said connections and allows for RoboKit's server to receive
/// multiple clients simultaniously.
@Observable public class Connection: @unchecked Sendable {
    /// Static ID necessary for the differentiation of each connection's identification  in the server's
    /// `connectionsByID` dictionary.
    nonisolated(unsafe) private static var nextID: Int = 0
    let nwConnection: NWConnection
    /// The unique identification to a connection. Assigned based on the static `nextID` property
    let id: Int
    var didStopCallback: ((Error?) -> Void)?
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    /// Initializes the Connection instance, assigning it an Integer ID
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        self.id = Connection.nextID
        Connection.nextID += 1
        Task { @MainActor in
            Connection.log("New connection created with ID: \(self.id)", level: .debug)
        }
    }
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
    /// Function to handle the connections states.
    /// The state update handler administers the possible NWConnection statuses
    /// and calls helper methods accordingly
    private func stateDidChange(to state: NWConnection.State) {
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
    /// Method that cancels the connection once it fails.
    /// - Parameters:
    ///  - error: the error that occurred to cause the failure
    private func connectionDidFail(error: Error) {
        if let failedConnection = failedConnection {
            failedConnection()
        }
        Task { @MainActor in
            Connection.log("Connection \(self.id) failed with error: \(error)", level: .error)
        }
        self.stop(error: error)
    }
    /// Method that cancels the connection once it is ended.
    private func connectionDidEnd() {
        Task { @MainActor in
            Connection.log("Connection \(self.id) ended", level: .info)
        }
        self.stop(error: nil)
    }
    /// Method responsible for cleaning up the Connections stateUpdateHandler and CallBack once it is ended or fails.
    /// - Parameters:
    ///  - error: In case of failure, this is the error that caused it
    private func stop(error: Error?) {
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

    /// Method resposible for receiving and decoding messages from clients.
    public func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            guard let data = data else { return }
            do {
                let message: JSONMessageModel = try JSONManager.decodeFromJSON(data: data)
                if type(of: message) == JSONMessageModel.self {
                    Task { @MainActor in
                        Connection.log(
                            "Connection \(self.id) received JSON message: [Claw Control: \(message.clawControl), Position & Rotation: \(message.positionAndRotation)]",
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
