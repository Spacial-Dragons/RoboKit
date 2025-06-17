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

import SwiftUI

/// A SwiftUI view that displays rotation information for a specific Euler angle in the input sphere context.
///
/// This view shows the current rotation value for a given Euler angle (pitch/X, yaw/Y, or roll/Z)
/// in the input sphere. It displays the axis label and the formatted rotation value in degrees
/// in a horizontal stack layout.
///
/// ## Usage
/// ```swift
/// InputSphereRotationText(eulerAngle: .pitch) // Displays X-axis rotation
/// InputSphereRotationText(eulerAngle: .yaw) // Displays Y-axis rotation
/// InputSphereRotationText(eulerAngle: .roll) // Displays Z-axis rotation
/// ```
public struct InputEntityRotationText: View {
    /// The input sphere manager that provides rotation data from the input sphere system.
    @Environment(InputEntityManager.self) private var inputEntityManager: InputEntityManager

    /// The Euler angle for which to display rotation information.
    private let eulerAngle: EulerAngle

    /// Initializes a new input sphere rotation text view.
    ///
    /// - Parameter eulerAngle: The Euler angle (pitch/X, yaw/Y, or roll/Z) for which
    ///                         to display rotation information.
    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }

    /// Retrieves the rotation value for the specified Euler angle from the input sphere manager.
    ///
    /// This computed property accesses the rotation data from the input sphere system,
    /// converts it from radians to degrees, and returns the formatted value for display.
    private var angleValue: Float? {
        inputEntityManager.inputEntityEulerAngles[eulerAngle]?.toDegrees ?? 0
    }

    /// Returns the display label for the current Euler angle.
    ///
    /// This property provides a human-readable label that corresponds to the Euler angle
    /// being displayed, using the format "Rotation X", "Rotation Y", or "Rotation Z".
    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return "Rotation X"
        case .yaw: return "Rotation Y"
        case .roll: return "Rotation Z"
        }
    }

    public var body: some View {
        HStack {
            Text(axisLabel)
            Text(angleValue.map { String(format: "%.0f°", $0) } ?? "NA")
                .foregroundStyle(.secondary)
        }
    }
}
