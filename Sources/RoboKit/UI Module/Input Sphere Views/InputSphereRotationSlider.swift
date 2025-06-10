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
import RealityFoundation

/// A SwiftUI view that provides a slider control for rotation values in the input sphere context.
///
/// This view creates an interactive slider that allows users to adjust rotation values
/// for a specific Euler angle (pitch/X, yaw/Y, or roll/Z) in the input sphere. The slider
/// is bound to the input sphere manager and updates the rotation data in real-time, with
/// automatic conversion between radians and degrees.
///
/// ## Usage
/// ```swift
/// InputSphereRotationSlider(
///     rootPoint: entity,
///     eulerAngle: .pitch,
///     maxValue: 180,
///     minValue: -180,
///     step: 1,
///     showMinMax: true
/// )
/// ```
public struct InputSphereRotationSlider: View {
    /// The input sphere manager that provides and manages rotation data from the input sphere system.
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    
    /// The root entity point relative to which rotations are calculated.
    let rootPoint: Entity
    
    /// The Euler angle for which to provide rotation control.
    let eulerAngle: EulerAngle
    
    /// The maximum rotation value in degrees.
    let maxValue: Float
    
    /// The minimum rotation value in degrees.
    let minValue: Float
    
    /// The step increment for the slider in degrees.
    let step: Float
    
    /// Whether to display minimum and maximum value labels.
    let showMinMax: Bool

    /// Initializes a new input sphere rotation slider view.
    ///
    /// - Parameters:
    ///   - rootPoint: The root entity point relative to which rotations are calculated.
    ///   - eulerAngle: The Euler angle (pitch/X, yaw/Y, or roll/Z) for which to provide rotation control.
    ///   - maxValue: The maximum rotation value in degrees. Defaults to 180.
    ///   - minValue: The minimum rotation value in degrees. Defaults to -180.
    ///   - step: The step increment for the slider in degrees. Defaults to 1.
    ///   - showMinMax: Whether to display minimum and maximum value labels. Defaults to false.
    public init(rootPoint: Entity,
                eulerAngle: EulerAngle,
                maxValue: Float = 180,
                minValue: Float = -180,
                step: Float = 1,
                showMinMax: Bool = false
    ) {
        self.rootPoint = rootPoint
        self.eulerAngle = eulerAngle
        self.maxValue = maxValue
        self.minValue = minValue
        self.step = step
        self.showMinMax = showMinMax
    }

    /// Creates a binding to the rotation value for the specified Euler angle.
    ///
    /// This computed property provides a two-way binding that allows reading and writing
    /// to the rotation data. When the user adjusts the slider, the corresponding rotation
    /// component is automatically updated in the input sphere manager, and the input sphere
    /// is rotated and updated relative to the root point.
    private var angleValue: Binding<Float> {
        Binding(
            get: { inputSphereManager.inputSphereEulerAngles[eulerAngle] ?? 0 },
            set: {
                inputSphereManager.inputSphereEulerAngles[eulerAngle] = $0
                inputSphereManager.rotateInputSphere()
                inputSphereManager.updateInputSphereRotation(relativeToRootPoint: rootPoint)
            }
        )
    }

    /// Returns the display label for the current Euler angle.
    ///
    /// This property provides a human-readable label that corresponds to the Euler angle
    /// being controlled. When `showMinMax` is true, it returns just the axis letter (X, Y, Z);
    /// otherwise, it returns the full description (Rotation X, Rotation Y, Rotation Z).
    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return showMinMax ? "X" : "Rotation X"
        case .yaw: return showMinMax ? "Y" : "Rotation Y"
        case .roll: return showMinMax ? "Z" : "Rotation Z"
        }
    }

    public var body: some View {
        HStack {
            Text(axisLabel)

            if showMinMax {
                Text("\(Int(minValue))°")
                    .foregroundStyle(.secondary)
                    .fontDesign(.monospaced)
            }

            VStack {
                if showMinMax {
                    angleText(value: Float(angleValue.wrappedValue))
                }

                Slider(
                    value: angleValue,
                    in: minValue.toRadians...maxValue.toRadians,
                    step: step.toRadians
                )
                .accessibilityLabel(Text("\(axisLabel) angle"))
                .accessibilityValue(Text("\(Int(angleValue.wrappedValue.toDegrees)) degrees"))
            }
            .padding(.horizontal)

            if showMinMax {
                Text("\(Int(maxValue))°")
                    .foregroundStyle(.secondary)
                    .fontDesign(.monospaced)
            } else {
                Text("-999°")
                    .fontDesign(.monospaced)
                    .hidden()
                    .overlay(alignment: .trailing) {
                        angleText(value: Float(angleValue.wrappedValue))
                    }
            }
        }
    }

    /// Creates a text view displaying the current angle value in degrees.
    ///
    /// - Parameter value: The angle value in radians to convert and display.
    /// - Returns: A text view showing the angle in degrees with monospaced font design.
    @ViewBuilder
    private func angleText(value: Float) -> some View {
        Text("\(Int(value.toDegrees))°")
            .fontDesign(.monospaced)
    }
}
