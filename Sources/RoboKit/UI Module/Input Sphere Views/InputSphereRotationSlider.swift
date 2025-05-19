//
//  InputSphereRotationSlider.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import SwiftUI

/// A SwiftUI view that provides a slider to adjust one of the Input Sphere's Euler angles.
///
/// `InputSphereRotationSlider` binds to a specific `EulerAngle` (roll, yaw, or pitch)
/// and allows users to update its value via a slider input in degrees. The underlying
/// rotation is stored in radians and managed by the `InputSphereManager`.
///
/// This view is useful for fine-tuning robot end-effector orientation in AR environments
/// using intuitive slider controls.
///
/// ```swift
/// InputSphereRotationSlider(eulerAngle: .yaw)
/// ```
///
/// - Note: The angle is displayed in degrees, while the value is stored internally in radians.
///
/// - Parameters:
///   - eulerAngle: The Euler angle to control. Options are `.roll`, `.yaw`, or `.pitch`.
public struct InputSphereRotationSlider: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let eulerAngle: EulerAngle
    let maxValue: Float = 180
    let minValue: Float = -180
    let step: Float = 1

    /// Initializes a slider for a specific Euler angle.
    ///
    /// - Parameter eulerAngle: The Euler angle this slider adjusts.
    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }

    /// Retrieves the appropriate binding for the selected Euler angle from the manager.
    private var angleValue: Binding<Float> {
        Binding(
            get: { inputSphereManager.inputSphereEulerAngles[eulerAngle] ?? 0 },
            set: { inputSphereManager.inputSphereEulerAngles[eulerAngle] = $0 }
        )
    }

    /// The label for the angle, capitalized for display.
    private var angleLabel: String {
        switch eulerAngle {
        case .roll: return "Roll"
        case .yaw: return "Yaw"
        case .pitch: return "Pitch"
        }
    }

    /// The content and layout of the slider view.
    public var body: some View {
        VStack {
            /// Text displaying the current angle value in degrees.
            Text("\(Int(angleValue.wrappedValue.toDegrees))°")
                .padding(.leading, 50)

            /// Slider with labels for min, max, and current value.
            VStack(alignment: .leading) {
                HStack {
                    Text("\(angleLabel):")
                    Text("\(String(format: "%.0f", minValue))°")
                    Slider(
                        value: angleValue,
                        in: (minValue.toRadians)...(maxValue.toRadians),
                        step: step.toRadians
                    )
                    Text("\(String(format: "%.0f", maxValue))°")
                }
            }
        }
    }
}
