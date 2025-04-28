//
//  MessageModel.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network

enum JSONErrors: Error {
    case undecodable
    case unknown
}

struct JSONMessageModel: Codable {
    let clawControl: Bool
    let positionAndRotation: [Float]
}


struct JSONManager {
    /// Generates different variations of mock `UserData` objects for testing.
    static func encodeToJSON(data: JSONMessageModel) -> Data {
        let encoder = JSONEncoder()
        var finalMessage = Data()

        do {
            
            finalMessage = try encoder.encode(data)
            
        } catch {
            print("❌ JSON Encoding error: \(error)")
        }
        
        return finalMessage
    }
    
    
    static func decodeFromJSON(data: Data) throws -> JSONMessageModel {
        let decoder = JSONDecoder()
        let finalMessage: JSONMessageModel? = try decoder.decode(JSONMessageModel.self, from: data)
        
        if let fm = finalMessage  {
            return fm
        } else {
            throw JSONErrors.undecodable
        }
    }
    
}
