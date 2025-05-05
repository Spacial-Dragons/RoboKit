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
    /// A static log to record server/connection events.
//    static var log: [String] = []
    
    /// The server's conenction listener.
    public let listener: NWListener

    /// This array and the existence of the `Connection` class allow for the connection of multiple clients to this server at once.
    private var connectionsByID: [Int: Connection] = [:]
    
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)? = nil
    
    /// Initializes the server's listener. Server is NOT yet ready for connections.
    public init(port: NWEndpoint.Port) {
        self.listener = try! NWListener(using: .tcp, on: port)
    }

    /// Starts the server. After this function is called, server is ready to receive connection requests from clients.
    /// - Parameters:
    ///  - logMessage: Optional message to add to the server log once this method is called.
    func start(logMessage: String? ) throws {
        if let message = logMessage {
//            self.log.append(message)
        }
        
        self.listener.stateUpdateHandler = self.stateDidChange(to:)
        self.listener.newConnectionHandler = self.didAccept(nwConnection:)
        self.listener.start(queue: .main)
    }

    /// The state handler for the server.
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .setup:
            break
        case .waiting:
            break
        case .ready:
            break
        case .failed(let error):
//            self.log.append("Server failed with error: \(error)")
            self.stop()
        case .cancelled:
            break
        default:
            break
        }
    }

    /// Determines what should be done when the server accepts a new connection, and assigns the individual connection methods.
    /// - Parameters:
    ///  - nwConnection: the new connection stablished with a client.
    private func didAccept(nwConnection: NWConnection) {
        let connection = Connection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        connection.start(values: nil)
        
        
        connection.setupConnection = self.setupConnection
        connection.waitingConnection = self.waitingConnection
        connection.preparingConnection = self.preparingConnection
        connection.readyConnection = self.readyConnection
        connection.failedConnection = self.failedConnection
        connection.cancelledConnection = self.cancelledConnection
        
//        self.log.append("Server did open connection \(connection.id)")
        
    }
    /// Helper method that manages the server's dictionary of connections when the server has a connection ended.
    /// - Parameters:
    ///  - connection: the connection that was concluded.
    private func connectionDidStop(_ connection: Connection) {
        self.connectionsByID.removeValue(forKey: connection.id)
//        self.log.append("Server closed connection \(connection.id)")
    }

    /// Helper method that cancels a connection when it's cancelled or fails.
    private func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            //Server.log.append("Connection \(self.id) has stopped")
        }
        self.connectionsByID.removeAll()
    }
    
}

/// The `Connection` class is responsible for representing each client connection to the server. It handles the logic for said connections and allows for RoboKit's server to receive multiple clients simultaniously.
@Observable class Connection: @unchecked Sendable {
    
    /// Static ID necessary for the differentiation of each connection's identification  in the server's `connectionsByID` dictionary.
    nonisolated(unsafe) private static var nextID: Int = 0

    let nwConnection: NWConnection
    
    /// The unique identification to a connection. Assigned based on the static `nextID` property
    let id: Int
    
    var didStopCallback: ((Error?) -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)? = nil
    
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)? = nil

    ///Initializes the Connection instance, assigning it an Integer ID
    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        self.id = Connection.nextID
        Connection.nextID += 1
        
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
    }


    /// Sends data from the server to the client
    /// - Parameters:
    ///  - data: The data that should be sent
    func send(data: Data) {
        self.nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
//            Server.log.append("Connection \(self.id) did send, data: \(data as NSData)")

        }))
    }

    /// Function to handle the connections states. The state update handler administers the possible NWConnection statuses and calls helper methods accordingly
    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .setup:
            if let setupConnection = setupConnection {
                setupConnection()
            }
            break
        case .waiting(let error):
            if let waitingConnection = waitingConnection {
                waitingConnection()
            }
            self.connectionDidFail(error: error)
        case .preparing:
            if let preparingConnection = preparingConnection {
                preparingConnection()
            }
            break
        case .ready:
            if let readyConnection = readyConnection {
                readyConnection()
            }
//            Server.log.append("Connection \(self.id) ready")
        case .failed(let error):
            self.connectionDidFail(error: error)
        case .cancelled:
            if let cancelledConnection = cancelledConnection {
                cancelledConnection()
            }
            break
        default:
            break
        }
    }

    /// Method that cancels the connection once it fails.
    /// - Parameters:
    ///  - error: the error that occurred to cause the failure
    private func connectionDidFail(error: Error) {
        if let failedConnection = failedConnection {
            failedConnection()
        }
//        Server.log.append("Connection \(self.id) failed with error: \(error)")
        self.stop(error: error)
    }
    /// Method that cancels the connection once it is ended.
    private func connectionDidEnd() {
        
//        Server.log.append("Connection \(self.id) did end")
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
    }

    /// Method resposible for receiving and decoding messages from clients.
    public func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            
            guard let data = data else { return }
            
            do {
                let message = try JSONManager.decodeFromJSON(data: data)
                
                if type(of: message) == JSONMessageModel.self {
//                    Server.log.append("---------------------------\nConnection \(self.id) did receive data: \n\(message)")
                }
            } catch {
                print("ops")
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
