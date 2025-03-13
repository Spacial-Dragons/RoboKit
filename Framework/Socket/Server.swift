//
//  Server.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network
import SwiftUI


@Observable class ServerLog {
    static var log: [String] = []
}

@Observable public class Server {
    
    let listener: NWListener
    
    init() {
        self.listener = try! NWListener(using: .tcp, on: Settings.port)
    }

    func start() throws {
        ServerLog.log.append("Server will start")
        self.listener.stateUpdateHandler = self.stateDidChange(to:)
        self.listener.newConnectionHandler = self.didAccept(nwConnection:)
        self.listener.start(queue: .main)
    }

    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .setup:
            break
        case .waiting:
            break
        case .ready:
            break
        case .failed(let error):
            ServerLog.log.append("Server failed with error: \(error)")
            self.stop()
        case .cancelled:
            break
        default:
            break
        }
    }

    private var connectionsByID: [Int: Connection] = [:]

    private func didAccept(nwConnection: NWConnection) {
        let connection = Connection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        connection.start(values: nil)
        ServerLog.log.append("Server did open connection \(connection.id)")
        
    }

    private func connectionDidStop(_ connection: Connection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        ServerLog.log.append("Server closed connection \(connection.id)")
    }

    private func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.stop()
        }
        self.connectionsByID.removeAll()
    }
    
}

@Observable class Connection {
    
    private static var nextID: Int = 0

    let nwConnection: NWConnection
    let id: Int
    
    var didStopCallback: ((Error?) -> Void)? = nil
    
    var log = ServerLog.log

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        self.id = Connection.nextID
        Connection.nextID += 1
        
    }

    func start(values: [Int]?) {
        ServerLog.log.append("Connection \(self.id) will start")
        self.nwConnection.stateUpdateHandler = self.stateDidChange(to:)
        self.setupReceive()
        if let values = values{
            let data: [Int] = values
            let convertedData = Data(data.description.utf8)
            self.send(data: convertedData)
        }
        self.nwConnection.start(queue: .main)
    }

    func send(data: Data) {
        self.nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            ServerLog.log.append("Connection \(self.id) did send, data: \(data as NSData)")

        }))
    }

    func stop() {
        ServerLog.log.append("Connection \(self.id) has stopped")
        
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            self.connectionDidFail(error: error)
        case .preparing:
            break
        case .ready:
            ServerLog.log.append("Connection \(self.id) ready")
        case .failed(let error):
            self.connectionDidFail(error: error)
        case .cancelled:
            break
        default:
            break
        }
    }

    private func connectionDidFail(error: Error) {
        
        ServerLog.log.append("Connection \(self.id) failed with error: \(error)")
        self.stop(error: error)
    }

    private func connectionDidEnd() {
        
        ServerLog.log.append("Connection \(self.id) did end")
        self.stop(error: nil)
    }

    private func stop(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }

    private func setupReceive() {
        self.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            
            guard let data = data else { return }
            
            do {
                let message = try JSONManager.decodeFromJSON(data: data)
                
                if type(of: message) == JSONMessageModel.self {
                    ServerLog.log.append("---------------------------\nConnection \(self.id) did receive data: \n\(message)")
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
