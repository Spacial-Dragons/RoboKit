//
//  Client.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network
import SwiftUI

@ObservableObject
public final class TCPClient {
    
    public var connection: NWConnection?
    //    public var latestReceivedMessage: String = ""
    @Published public var log: [String] = []
    public var host: NWEndpoint.Host
    public var port: NWEndpoint.Port

    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        
        self.host = host
        self.port = port
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    public func startConnection(value: Data){
        
        self.connection?.stateUpdateHandler = {state in
            
            self.log.append("Client will start connection...Current state: \(state)")
            
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
                self.log.append("Ready")
                self.connectionReady()
            case .failed(_):
                //                self.log.append("Connection failed")
                self.connectionFailed()
                //                self.connection?.cancel()
                
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
    
    public func receiveMessage(minLength min: Int = 1, maxLength max: Int){
        
        self.connection?.receive(minimumIncompleteLength: min, maximumLength: max, completion: { data, _, isComplete, error in
            if let data = data, !data.isEmpty{
                
                self.log.append("---------------------------\nClient sent data: \n\(String(data: data, encoding: .utf8) ?? "error")")
            }
            
            if isComplete {
                self.connectionEnded()
                
            } else if let error = error{
                self.log.append("Error \(error) when receiving message")
            } else {
                self.receiveMessage()
            }
        })
    }
    
    public func connectionEnded(){
        self.log.append("Ending and closing the connection")
        self.connection?.cancel()
    }
    
    public func sendMessage(data: Data){
        self.log.append("tried to send, \(String(describing: self.connection?.state))")
        self.connection?.send(content: data, completion: .contentProcessed({ error in
            if let _ = error {
                self.log.append("sending failed")
                self.connectionFailed()
                
                return
            }
            self.log.append("---------------------------\nClient sent data: \n\(String(data: data, encoding: .utf8) ?? "error")")
        }))
    }
    
    public func connectionFailed(){
        self.log.append("connection failed")
        print("connection failed")
        self.connection?.stateUpdateHandler = nil
        self.connection?.cancel()
    }
    
    //MARK: - Maybe these should be computed variables that only have 'set'
    
    //Determines what should be executed during the setup of the connection
    public func setUpConnection(logMessage: String?, _ setup: (() -> Void)?){
        if let message = logMessage {
            self.log.append(message)
        }
        if let setup = setup{
            setup()
        }
    }
    
    //For the waiting stage. So far it seems that its best to cancel the connection here. The "connectionFailed" function was being used in
    //the waiting stage originally
    public func connectionWaiting(logMessage: String?, _ waiting: (() -> Void)?){
        
        if let message = logMessage {
            self.log.append(message)
        }
        if let waiting = waiting{
            waiting()
        }
    }
    
    public func connectionPreparing(logMessage: String?, _ preparing: (() -> Void)?){
        if let message = logMessage {
            self.log.append(message)
        }
        if let preparing = preparing{
            preparing()
        }
    }
    
    public func connectionReady(_ ready: (() -> Void)?) {
        
        //Do I really need this here? It's already in the start Connection
        self.receiveMessage()
        self.sendMessage(data: value)
        self.connection?.start(queue: .main)
    }
    
    public func connectionCanceled(logMessages: String?, _ canceled(() -> Void)?) {
        if let message = logMessage {
            self.log.append(message)
        }
        
    }
    
}

