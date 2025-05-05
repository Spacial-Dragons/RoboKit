//
//  MessageModel.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network

/// Possible errors from the JSON encoding and decoding process
enum JSONErrors: Error {
    case undecodable
    case unknown
}

/// Model for the message that the`TCPClient` can send to the `Server`
public struct JSONMessageModel: Codable {
    let clawControl: Bool
    let positionAndRotation: [Float]
}

/// Manager for the encoding and decoding of the JSON messages
public struct JSONManager {
    
    /// Encodes JSON messages before sending them
    static func encodeToJSON<T: Codable>(data: T) -> Data {
        let encoder = JSONEncoder()
        var finalMessage = Data()

        do {
            
            finalMessage = try encoder.encode(data)
            
        } catch {
            print("❌ JSON Encoding error: \(error)")
        }
        
        return finalMessage
    }
    
    /// Decodes JSON messages as they are received
    static func decodeFromJSON<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let finalMessage: T? = try decoder.decode(T.self, from: data)
        
        if let fm = finalMessage  {
            return fm
        } else {
            throw JSONErrors.undecodable
        }
    }
    
}
