//
//  Client.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation
import Network
import SwiftUI

///The TCP Client class holds the logic for the client of our TCP connection.
@Observable public class TCPClient: @unchecked Sendable {
    
    /// The connection to the server
    public var connection: NWConnection?
    
    /// Host and Port of the server the client should connect to
    public var host: NWEndpoint.Host
    public var port: NWEndpoint.Port
    
    public var setupConnection: (() -> Void)? = nil
    public var waitingConnection: (() -> Void)? = nil
    public var preparingConnection: (() -> Void)? = nil
    public var readyConnection: (() -> Void)? = nil
    public var failedConnection: (() -> Void)? = nil
    public var cancelledConnection: (() -> Void)? = nil
    
    
    /// Initializes the client and the connection instance to the server. Warning: Connection is not yet running here.
    init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        self.host = host
        self.port = port
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    /// Function to start the conenction to the server. The state update handler administers the possible NWConnection statuses and calls helper methods accordingly
    public func startConnection(value: Data){
        
        self.connection?.stateUpdateHandler = {state in
            
//            self.clientLog.append("Client will start connection...Current state: \(state)")
            
            switch state{
            case .setup:
                self.setUpConnection()
                break
            case .waiting(_):
                self.connectionWaiting()
                
            case .preparing:
                self.connectionPreparing()
                break
                
            case .ready:
//                self.clientLog.append("Ready")
                self.connectionReady(value: value)
            case .failed(_):
                
                self.connectionFailed()
//                                self.connection?.cancel()
                
            case .cancelled:
                self.connectionCanceled()
                break
            default:
                break
                
            }
        }
        
        self.receiveMessage()
        self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
    
    /// Receives messages sent from the server to the client
    /// - Parameters:
    ///   - minLength: The minimum length in bytes to receive from the connection, until the content is complete. If unnassigned, it will be set to 1
    ///   - maxLength: The maximum length to receive from the connection at once. If unnasigned, it will be set to 65536 bytes
    public func receiveMessage(minLength min: Int = 1, maxLength max: Int = 65536){
        
        self.connection?.receive(minimumIncompleteLength: min, maximumLength: max, completion: { data, _, isComplete, error in
            if let data = data, !data.isEmpty{
                
//                self.clientLog.append("---------------------------\nClient sent data: \n\(String(data: data, encoding: .utf8) ?? "error")")
            }
            
            if isComplete {
                self.connectionEnded()
                
            } else if let error = error{
//                self.clientLog.append("Error \(error) when receiving message")
            } else {
                self.receiveMessage()
            }
        })
    }
    
    /// Ends the connection to the server
    public func connectionEnded(){
//        self.clientLog.append("Ending and closing the connection")
        self.connection?.cancel()
    }
    
    /// Sends message from the client to the designated server. A connection must be established and running before this is called
    /// - Parameters:
    ///    - data: the data that should be sent to the server
    public func sendMessage(data: Data){
//        self.clientLog.append("tried to send, \(String(describing: self.connection?.state))")
        self.connection?.send(content: data, completion: .contentProcessed({ error in
            if let _ = error {
//                self.clientLog.append("sending failed")
                self.connectionFailed()
                
                return
            }
//            self.clientLog.append("---------------------------\nClient sent data: \n\(String(data: data, encoding: .utf8) ?? "error")")
        }))
    }
    /// Adds message to the server log, equates the `stateUpdateHandler` to nil and cancels the NWConnection. Called when the State Handler is on "cancelled"
    public func connectionFailed(){
//        self.clientLog.append("connection failed")
        self.connection?.stateUpdateHandler = nil
        self.connection?.cancel()
    }
    
    
    /// Determines what should be executed during the setup of the connection.
    public func setUpConnection(){
        if let setup = setupConnection{
            setup()
        }
    }
    
    //For the waiting stage. So far it seems that its best to cancel the connection here. The "connectionFailed" function was being used in
    //the waiting stage originally
    /// Determines the logic that should be implemented when the State Handler is in `waiting`
    public func connectionWaiting(){
        if let waiting = waitingConnection{
            waiting()
        }
    }
    
    
    /// Determines the logic that should be implemented when the State Handler is in `preparing`
    public func connectionPreparing(){
        if let preparing = preparingConnection{
            preparing()
        }
    }
    
    
    /// Determines the logic that should be implemented when the State Handler is in `ready`. This is where the main connection logic should be implemented
    /// - Parameters:
    ///   - value: the value that will be sent to the server as soon as the connection starts
    public func connectionReady(value: Data) {
        if let ready = readyConnection{
            ready()
        }
        self.receiveMessage()
        self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
    
    
    /// Determines the logic that should be implemented when the State Handler is in `cancelled`
    public func connectionCanceled() {
        if let canceled = cancelledConnection {
            canceled()
        }
        
    }
    
}
