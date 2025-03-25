//
//  Client.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network
import SwiftUI

public final class TCPClient {
    
    public var connection: NWConnection?
    public var latestReceivedMessage: String = ""
    public var log: [String] = []
    public var host: NWEndpoint.Host
    public var port: NWEndpoint.Port
    
    
    init() {
        //Initializes the connection with the given host and port. Connection is not running yet
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    init(host: NWEndpoint.Host?, port: NWEndpoint.Port?) {
        if let host = host{
            self.host = host
        }
        
        if let port = port{
            self.port = port
        }
        
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    public func startConnection(value: Data){

        self.connection?.stateUpdateHandler = {state in

            self.log.append("Client will start connection...Current state: \(state)")
            switch state{
            case .setup:
                self.log.append("Setup")
                self.setUpConnection()
                break
            case .waiting(_):
                self.log.append("Waiting")
                self.connectionWaiting()
//                self.connectionFailed()
            case .preparing:
                self.log.append("Preparing")
                self.connectionPreparing()
                break
            case .ready:
                self.log.append("Ready")
            case .failed(_):
//                self.log.append("Connection failed")
                self.connectionFailed
//                self.connection?.cancel()
            case .cancelled:
                self.log.append("Connection cancelled")
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
    public func setUpConnection(_ setup: (() -> Void)?){
        if let setup = setup{
            setup()
        }
    }
    
    //For the waiting stage. So far it seems that its best to cancel the connection here. The "connectionFailed" function was being used in
    //the waiting stage originally
    public func connectionWaiting(_ waiting: (() -> Void)?){
        if let waiting = waiting{
            waiting()
        }
    }
    
    public func connectionPreparing(_ preparing: (() -> Void)?){
        if let preparing = preparing{
            preparing()
        }
    }
    
}

