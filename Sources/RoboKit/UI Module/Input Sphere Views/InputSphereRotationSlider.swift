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

public struct InputSphereRotationSlider: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let rootPoint: Entity
    let eulerAngle: EulerAngle
    let maxValue: Float
    let minValue: Float
    let step: Float
    let showMinMax: Bool

    /// Initializes a slider for a specific Euler angle.
    ///
    /// - Parameter eulerAngle: The Euler angle this slider adjusts.
    public init(rootPoint: Entity,
                eulerAngle: EulerAngle,
                maxValue: Float = 180,
                minValue: Float = -180,
                step: Float = 1,
                showMinMax: Bool = false,
    ) {
        self.rootPoint = rootPoint
        self.eulerAngle = eulerAngle
        self.maxValue = maxValue
        self.minValue = minValue
        self.step = step
        self.showMinMax = showMinMax
    }

    /// Retrieves the appropriate binding for the selected Euler angle from the manager.
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

    /// The label for the axis, capitalized for display.
    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return showMinMax ? "X" : "Rotation X"
        case .yaw: return showMinMax ? "Y" : "Rotation Y"
        case .roll: return showMinMax ? "Z" : "Rotation Z"
        }
    }

    /// The content and layout of the slider view.
    public var body: some View {
        if showMinMax {
            VStack {
                /// Text displaying the current angle value in degrees.
                Text("\(Int(angleValue.wrappedValue.toDegrees))°")
                    .padding(.leading, 35)
                HStack {
                    Text(axisLabel)
                        .padding(.trailing)
                    Text("\(String(format: "%.0f", minValue))°")
                    Slider(
                        value: angleValue,
                        in: (minValue.toRadians)...(maxValue.toRadians),
                        step: step.toRadians
                    )
                    Text("\(String(format: "%.0f", maxValue))°")
                }
            }
        } else {
            HStack {
                Text(axisLabel)
                    .padding(.trailing)
                Slider(
                    value: angleValue,
                    in: (minValue.toRadians)...(maxValue.toRadians),
                    step: step.toRadians
                )
                Text("\(Int(angleValue.wrappedValue.toDegrees))°")
                    .frame(width: 50)
            }
        }
    }
}
