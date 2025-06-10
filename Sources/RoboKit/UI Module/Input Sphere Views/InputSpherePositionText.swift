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

/// A SwiftUI view that displays position information for a specific axis in the input sphere context.
///
/// This view shows the current position value for a given axis (X, Y, or Z) relative to the
/// root coordinate system in the input sphere. It displays the axis label and the formatted
/// position value in a horizontal stack layout with proper accessibility support.
///
/// ## Usage
/// ```swift
/// InputSpherePositionText(axis: .lateral) // Displays X-axis position
/// InputSpherePositionText(axis: .longitudinal) // Displays Y-axis position
/// InputSpherePositionText(axis: .vertical) // Displays Z-axis position
/// InputSpherePositionText(axis: .lateral, showFullDescription: true) // Shows "Position X"
/// ```
public struct InputSpherePositionText: View {
    /// The input sphere manager that provides position data from the input sphere system.
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    
    /// The axis for which to display position information.
    private let axis: Axis
    
    /// Whether to show the full description (e.g., "Position X") instead of just the axis label.
    private let showFullDescription: Bool

    /// Initializes a new input sphere position text view.
    ///
    /// - Parameters:
    ///   - axis: The axis (lateral/X, longitudinal/Y, or vertical/Z) for which
    ///           to display position information.
    ///   - showFullDescription: Whether to show the full description instead of just the axis label.
    public init(axis: Axis, showFullDescription: Bool = false) {
        self.axis = axis
        self.showFullDescription = showFullDescription
    }

    /// Retrieves the position value for the specified axis from the input sphere manager.
    ///
    /// This computed property accesses the position data from the input sphere coordinate system,
    /// converts it to ROS coordinates, and returns the appropriate component based on the selected axis.
    private var positionValue: Float? {
        guard let position = inputSphereManager.inputSpherePositionRelativeToRoot
        else { return nil }
        let positionInROS = position.convertToROSCoordinateSystem()

        switch axis {
        case .lateral: return positionInROS.x
        case .longitudinal: return positionInROS.y
        case .vertical: return positionInROS.z
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
            if showFullDescription {
                Text("Position \(axisLabel)")
            } else {
                Text(axisLabel)
            }
            Text(formattedValue)
                .foregroundStyle(.secondary)
                .fontDesign(.monospaced)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Position on axis \(axisLabel): \(formattedValue)"))
    }
}
