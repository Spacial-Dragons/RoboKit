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

    public var body: some View {
        VStack {
            if showMinMax {
                angleText(padding: .leading, value: Float(angleValue.wrappedValue))
            }
            sliderRow(showMinMax: showMinMax)
        }
    }

    @ViewBuilder
    private func sliderRow(showMinMax: Bool) -> some View {
        HStack {
            Text(axisLabel)
                .padding(.trailing)

            if showMinMax {
                Text("\(Int(minValue))°")
            }

            Slider(
                value: angleValue,
                in: minValue.toRadians...maxValue.toRadians,
                step: step.toRadians
            )

            if showMinMax {
                Text("\(Int(maxValue))°")
            } else {
                angleText(padding: nil, value: Float(angleValue.wrappedValue))
                    .frame(width: 50)
            }
        }
    }

    @ViewBuilder
    private func angleText(padding: Edge.Set?, value: Float) -> some View {
        if let padding = padding {
            Text("\(Int(value.toDegrees))°")
                .padding(padding, 35)
        } else {
            Text("\(Int(value.toDegrees))°")
        }
    }
}
