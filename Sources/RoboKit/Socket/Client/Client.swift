//
//  Client.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Foundation
import Network
import SwiftUI

/// The TCP Client class holds the logic for the client of our TCP connection.
@Observable public final class TCPClient: @unchecked Sendable {
    /// The connection to the server
    public var connection: NWConnection?
    /// Host of the server the client should connect to
    public var host: NWEndpoint.Host
    /// Port of the server the client should connect to
    public var port: NWEndpoint.Port
    /// Custom logic for when the connection to the server is on `setup` state
    public var setupConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `waiting` state
    public var waitingConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `preparing` state
    public var preparingConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `ready` state
    public var readyConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `failed` state
    public var failedConnection: (() -> Void)?
    /// Custom logic for when the connection to the server is on `cancelled` state
    public var cancelledConnection: (() -> Void)?
    @MainActor
    func log(_ message: String, level: LogLevel) {
        AppLogger.shared.log(message, level: level, category: .socket)
    }

    /// Initializes the client and the connection instance to the server. Warning: Connection is not yet running here.
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        self.host = host
        self.port = port
        self.connection = NWConnection(host: host, port: port, using: .tcp)
        Task { @MainActor in
            log("TCPClient initialized with host: \(host) and port: \(port)", level: .info)
        }
    }
}
