//
//===----------------------------------------------------------------------===//
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
//===----------------------------------------------------------------------===//


import Network

public struct Settings {
    /// This IP address has to be altered each time the application is run, since it should be
    /// the IP address of the current server.
    static let host: NWEndpoint.Host = "localhost"
    static let port: NWEndpoint.Port = 12348

    /// Change this variable to 'false' whenever testing with an external server
    static let shouldRunServer: Bool = true
}
