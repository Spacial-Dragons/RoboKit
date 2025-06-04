//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //

import Foundation
import Network
import SwiftUI

public actor TCPServer {
    /// The server's conenction listener.
    public let listener: NWListener
    /// This array and the existence of the `Connection` class allow for the connection of
    /// multiple clients to this server at once.
    var connectionsByID: [Int: Connection] = [:]
    /// Initializes the server's listener. Server is NOT yet ready for
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    public init(port: UInt16) async throws {
        let parameters = NWParameters.tcp
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try NWListener(using: parameters, on: nwPort)
        await TCPServer.log("Server initialized on port \(port)", level: .info)
    }
}
