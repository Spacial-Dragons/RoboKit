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

/// The `Connection` class is responsible for representing each client connection to the server.
/// It handles the logic for said connections and allows for RoboKit's server to receive
/// multiple clients simultaniously.
@Observable public class Connection: @unchecked Sendable {
    /// Static ID necessary for the differentiation of each connection's identification  in the server's
    /// `connectionsByID` dictionary.
    nonisolated(unsafe) private static var nextID: Int = 0
    let nwConnection: NWConnection
    /// The unique identification to a connection. Assigned based on the static `nextID` property
    let id: Int
    var didStopCallback: ((Error?) -> Void)?
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
    /// Initializes the Connection instance, assigning it an Integer ID
    @MainActor
    static func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }
    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        self.id = Connection.nextID
        Connection.nextID += 1
        Task { @MainActor in
            Connection.log("New connection created with ID: \(self.id)", level: .debug)
        }
    }

}
