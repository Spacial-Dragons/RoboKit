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

@Observable public final class TCPServer: @unchecked Sendable {
    /// The server's conenction listener.
    public let listener: NWListener
    /// This array and the existence of the `Connection` class allow for the connection of
    /// multiple clients to this server at once.
    var connectionsByID: [Int: Connection] = [:]
    /// Custom logic for when the connection to the client is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the client is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    /// Initializes the server's listener. Server is NOT yet ready for
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    public init(port: UInt16) throws {
        let parameters = NWParameters.tcp
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try NWListener(using: parameters, on: nwPort)
        Task { @MainActor in
            TCPServer.log("Server initialized on port \(port)", level: .info)
        }
    }
}
