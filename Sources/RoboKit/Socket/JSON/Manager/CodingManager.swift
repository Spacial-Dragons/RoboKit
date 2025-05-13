//
//  MessageModel.swift
//  Framework
//
//  Created by Sofia Diniz Melo Santos on 13/03/25.
//

import Foundation
import Network

/// Manager for the encoding and decoding of the JSON messages
public struct CodingManager {
    @MainActor
    private static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    /// Encodes JSON messages before sending them
    static public func encodeToJSON<T: Codable>(data: T) -> Data {
        let encoder = JSONEncoder()
        var finalMessage = Data()

        do {
            finalMessage = try encoder.encode(data)
            Task { @MainActor in
                log("Successfully encoded JSON message: \(finalMessage)]", level: .debug)
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
    static func decodeFromJSON<T: Codable>(data: Data) throws -> T {
        do {
            let finalMessage = try JSONDecoder().decode(T.self, from: data)
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
