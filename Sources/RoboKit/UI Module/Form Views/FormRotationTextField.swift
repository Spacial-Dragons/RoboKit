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

/// A SwiftUI view that provides an editable text field for rotation values in a form context.
///
/// This view creates a text field that allows users to input and edit rotation values
/// for a specific Euler angle (pitch/X, yaw/Y, or roll/Z). The text field is bound to
/// the form manager and updates the Euler angles data in real-time.
///
/// ## Usage
/// ```swift
/// FormRotationTextField(eulerAngle: .pitch) // Editable X-axis rotation
/// FormRotationTextField(eulerAngle: .yaw) // Editable Y-axis rotation
/// FormRotationTextField(eulerAngle: .roll) // Editable Z-axis rotation
/// ```
public struct FormRotationTextField: View {
    /// The form manager that provides and manages rotation data from the ROS system.
    @Environment(FormManager.self) private var formManager: FormManager

    /// The Euler angle for which to provide rotation editing capabilities.
    private let eulerAngle: EulerAngle

    /// Initializes a new form rotation text field view.
    ///
    /// - Parameter eulerAngle: The Euler angle (pitch/X, yaw/Y, or roll/Z) for which
    ///                         to provide rotation editing capabilities.
    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }

    /// Creates a binding to the rotation value for the specified Euler angle.
    ///
    /// This computed property provides a two-way binding that allows reading and writing
    /// to the Euler angles data. When the user edits the text field, the corresponding
    /// rotation component is automatically updated in the form manager.
    private var angleValue: Binding<Float> {
        Binding(
            get: { formManager.formEulerAngles[eulerAngle] ?? 0 },
            set: { formManager.formEulerAngles[eulerAngle] = $0 }
        )
    }

    /// Returns the display label for the current Euler angle.
    ///
    /// This property provides a human-readable label that corresponds to the Euler angle
    /// being edited, using the format "Rotation X", "Rotation Y", or "Rotation Z".
    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return "Rotation X"
        case .yaw: return "Rotation Y"
        case .roll: return "Rotation Z"
        }
    }

    public var body: some View {
        HStack {
            Text("\(axisLabel)")

            TextField("", value: angleValue, format: .number)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(CapsuleTextFieldStyle())
                .accessibilityLabel(axisLabel)
        }
    }
}
