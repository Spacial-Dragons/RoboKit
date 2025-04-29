//
//  Settings.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 18/03/25.
//

import Network

public struct Settings {
    /// This IP address has to be altered each time the application is run, since it should be
    /// the IP address of the current server.
    static let host: NWEndpoint.Host = "localhost"
    static let port: NWEndpoint.Port = 12348

    /// Change this variable to 'false' whenever testing with an external server
    static let shouldRunServer: Bool = true
}
