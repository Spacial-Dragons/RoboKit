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

extension Float {
    /// Converts the value from degrees to radians.
    ///
    /// This computed property returns the angle in radians corresponding
    /// to the value interpreted as degrees. For example, `180.toRadians` returns `π`.
    ///
    /// ```swift
    /// let angleInRadians = 90.0.toRadians  // 1.5707964
    /// ```
    ///
    /// - Returns: The angle in radians.
    public var toRadians: Float {
        return self * .pi / 180
    }
}
