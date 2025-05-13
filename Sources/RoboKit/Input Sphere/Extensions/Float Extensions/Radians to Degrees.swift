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
    /// Converts the value from radians to degrees.
    ///
    /// This computed property returns the angle in degrees corresponding
    /// to the value interpreted as radians. For example, `Float.pi.toDegrees` returns `180`.
    ///
    /// ```swift
    /// let angleInDegrees = Float.pi.toDegrees  // 180.0
    /// ```
    ///
    /// - Returns: The angle in degrees.
    public var toDegrees: Float {
        return self * 180 / .pi
    }
}
