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

/// A SwiftUI view that displays position information for a specific axis in a form context.
///
/// This view shows the current position value for a given axis (X, Y, or Z) relative to the
/// root ROS coordinate system. It displays the axis label and the formatted position value
/// in a horizontal stack layout with proper accessibility support.
///
/// ## Usage
/// ```swift
/// FormPositionText(axis: .lateral) // Displays X-axis position
/// FormPositionText(axis: .longitudinal) // Displays Y-axis position
/// FormPositionText(axis: .vertical) // Displays Z-axis position
/// ```
public struct FormPositionText: View {
    /// The form manager that provides position data from the ROS system.
    @Environment(FormManager.self) private var formManager: FormManager
    
    /// The axis for which to display position information.
    private let axis: Axis

    /// Initializes a new form position text view.
    ///
    /// - Parameter axis: The axis (lateral/X, longitudinal/Y, or vertical/Z) for which
    ///                   to display position information.
    public init(axis: Axis) {
        self.axis = axis
    }

    /// Retrieves the position value for the specified axis from the form manager.
    ///
    /// This computed property accesses the position data from the ROS coordinate system
    /// and returns the appropriate component based on the selected axis.
    private var positionValue: Float? {
        let position = formManager.formPositionRelativeToRootROS

        switch axis {
        case .lateral: return position.x
        case .longitudinal: return position.y
        case .vertical: return position.z
        }
    }

    /// Returns the display label for the current axis.
    ///
    /// This property provides a human-readable label (X, Y, or Z) that corresponds
    /// to the axis being displayed.
    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }

    public var body: some View {
        let formattedValue = positionValue.map { String(format: "%.3f", $0) } ?? "NA"

        return HStack {
            Text(axisLabel)
            Text(formattedValue)
                .foregroundStyle(.secondary)
                .fontDesign(.monospaced)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Position on axis \(axisLabel): \(formattedValue)"))
    }
}
