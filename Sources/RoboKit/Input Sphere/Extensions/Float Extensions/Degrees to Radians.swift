//
//  Degrees to Radians.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

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
