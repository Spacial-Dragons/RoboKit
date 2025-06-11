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

/// Message model containing claw control, position, and rotation data.
public struct CPRMessageModel: Codable, Sendable, Equatable {
    public init(clawControl: Bool, positionAndRotation: [Double], objectWidth: Float) {
        self.clawControl = clawControl
        self.positionAndRotation = positionAndRotation
        self.objectWidth = objectWidth
    }

    public let clawControl: Bool
    public let positionAndRotation: [Double]
    public let objectWidth: Float
}
