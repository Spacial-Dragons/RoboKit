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
public struct JSONMessageModel: Codable, Sendable {
    let clawControl: Bool
    let positionAndRotation: [Float]
}

/// Manager for the encoding and decoding of the JSON messages
public struct JSONManager {
    @MainActor
    private static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

    /// Encodes JSON messages before sending them
    static func encodeToJSON(data: JSONMessageModel) -> Data {
        let encoder = JSONEncoder()
        var finalMessage = Data()

        do {
            finalMessage = try encoder.encode(data)
            Task { @MainActor in
                log("Successfully encoded JSON message: [Claw Control: \(data.clawControl), Position & Rotation: \(data.positionAndRotation)]", level: .debug)
            }
        } catch {
            let errorMessage = error.localizedDescription
            Task { @MainActor in
                log("Failed to encode JSON message: \(errorMessage)", level: .error)
            }
        }

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
    }
}
