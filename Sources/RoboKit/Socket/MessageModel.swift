//
//  MessageModel.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network

/// Possible errors from the JSON encoding and decoding process
public enum JSONErrors: Error {
    case undecodable
    case unknown
}

/// Model for the message that the`TCPClient` can send to the `Server`
<<<<<<< HEAD
public struct JSONMessageModel: Codable {
    public init(clawControl: Bool, positionAndRotation: [Float]) {
        self.clawControl = clawControl
        self.positionAndRotation = positionAndRotation
    }
    
    public let clawControl: Bool
    public let positionAndRotation: [Float]
=======
public struct JSONMessageModel: Codable, Sendable {
    let clawControl: Bool
    let positionAndRotation: [Float]
>>>>>>> origin/feat/socket-refactoring-error-handling
}

/// Manager for the encoding and decoding of the JSON messages
public struct JSONManager {
<<<<<<< HEAD
=======
    @MainActor
    private static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

>>>>>>> origin/feat/socket-refactoring-error-handling
    /// Encodes JSON messages before sending them
    static public func encodeToJSON<T: Codable>(data: T) -> Data {
        let encoder = JSONEncoder()
        var finalMessage = Data()

        do {
            finalMessage = try encoder.encode(data)
<<<<<<< HEAD
=======
            Task { @MainActor in
                log("Successfully encoded JSON message: [Claw Control: \(data.clawControl), Position & Rotation: \(data.positionAndRotation)]", level: .debug)
            }
>>>>>>> origin/feat/socket-refactoring-error-handling
        } catch {
            let errorMessage = error.localizedDescription
            Task { @MainActor in
                log("Failed to encode JSON message: \(errorMessage)", level: .error)
            }
        }
<<<<<<< HEAD
        return finalMessage
    }
    /// Decodes JSON messages as they are received
    static public func decodeFromJSON<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
=======

        return finalMessage
    }

    /// Decodes JSON messages as they are received
    static func decodeFromJSON(data: Data) throws -> JSONMessageModel {
        do {
            let finalMessage = try JSONDecoder().decode(JSONMessageModel.self, from: data)
        
            Task { @MainActor in
                log("Successfully decoded JSON message: [Claw Control: \(finalMessage.clawControl), Position & Rotation: \(finalMessage.positionAndRotation)]", level: .debug)
            }
            return finalMessage
        } catch {
            let errorMessage = error.localizedDescription
            Task { @MainActor in
                log("Failed to decode JSON message: \(errorMessage)", level: .error)
            }
            throw JSONErrors.undecodable
        }
>>>>>>> origin/feat/socket-refactoring-error-handling
    }
}
