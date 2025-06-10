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

/// A SwiftUI view that provides an editable text field for position values in a form context.
///
/// This view creates a text field that allows users to input and edit position values
/// for a specific axis (X, Y, or Z) relative to the root ROS coordinate system. The
/// text field is bound to the form manager and updates the ROS position data in real-time.
///
/// ## Usage
/// ```swift
/// FormPositionTextField(axis: .lateral) // Editable X-axis position
/// FormPositionTextField(axis: .longitudinal) // Editable Y-axis position
/// FormPositionTextField(axis: .vertical) // Editable Z-axis position
/// ```
public struct FormPositionTextField: View {
    /// The form manager that provides and manages position data from the ROS system.
    @Environment(FormManager.self) private var formManager: FormManager
    
    /// The axis for which to provide position editing capabilities.
    private let axis: Axis

    /// Initializes a new form position text field view.
    ///
    /// - Parameter axis: The axis (lateral/X, longitudinal/Y, or vertical/Z) for which
    ///                   to provide position editing capabilities.
    public init(axis: Axis) {
        self.axis = axis
    }

    /// Creates a binding to the position value for the specified axis in the ROS system.
    ///
    /// This computed property provides a two-way binding that allows reading and writing
    /// to the position data in the ROS coordinate system. When the user edits the text field,
    /// the corresponding position component is automatically updated in the form manager.
    private var positionValue: Binding<Float> {
        Binding(
            get: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRootROS.x
                case .longitudinal:
                    formManager.formPositionRelativeToRootROS.y
                case .vertical:
                    formManager.formPositionRelativeToRootROS.z
                }
            },
            set: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRootROS.x = $0
                case .longitudinal:
                    formManager.formPositionRelativeToRootROS.y = $0
                case .vertical:
                    formManager.formPositionRelativeToRootROS.z = $0
                }
            }
        )
    }

    /// Returns the display label for the current axis.
    ///
    /// This property provides a human-readable label (X, Y, or Z) that corresponds
    /// to the axis being edited, prefixed with "Position" for clarity.
    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }

    public var body: some View {
        HStack {
            Text("Position \(axisLabel)")

            TextField("", value: positionValue, format: .number)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(CapsuleTextFieldStyle())
                .accessibilityLabel(Text("Position \(axisLabel)"))
        }
    }
}
