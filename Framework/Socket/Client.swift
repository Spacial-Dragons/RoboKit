//
//  Client.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network
import SwiftUI

public final class FinalClient {
    
    public var connection: NWConnection?
    public var latestReceivedMessage: String = ""
    public var log: [String] = []
    
    init() {
        self.connection = NWConnection(host: Settings.host, port: Settings.port, using: .tcp)
    }
    
    public func startConnection(value: Data){

        self.connection?.stateUpdateHandler = {state in

            self.log.append("Client will start connection...Current state: \(state)")
            switch state{
            case .setup:

                self.log.append("Setup")
                break
            case .waiting(_):
                self.log.append("Waiting")
                self.connectionFailed()
            case .preparing:
                self.log.append("Preparing")
                break
            case .ready:
                self.log.append("Ready")
            case .failed(_):
                self.log.append("Connection failed")
                self.connection?.cancel()
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
    
    public func receiveMessage(){
        
        self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536, completion: { data, _, isComplete, error in
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
    
    
}

