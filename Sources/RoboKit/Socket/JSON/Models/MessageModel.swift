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

/// Model for the message that the`TCPClient` can send to the `Server`
public struct CPRMessageModel: Codable, Sendable {
    public init(clawControl: Bool, positionAndRotation: [Float]) {
        self.clawControl = clawControl
        self.positionAndRotation = positionAndRotation
    }

    public let clawControl: Bool
    public let positionAndRotation: [Float]
}
