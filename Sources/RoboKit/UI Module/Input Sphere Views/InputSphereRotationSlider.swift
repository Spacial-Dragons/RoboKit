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
        HStack {
            Text(axisLabel)

            if showMinMax {
                Text("\(Int(minValue))°")
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
            }
            .padding(.horizontal)

            if showMinMax {
                Text("\(Int(maxValue))°")
            } else {
                Text("-999°")
                    .hidden()
                    .overlay(alignment: .trailing) {
                        angleText(value: Float(angleValue.wrappedValue))
                    }
            }
        }
        .fontDesign(.monospaced)
    }

    @ViewBuilder
    private func angleText(value: Float) -> some View {
        Text("\(Int(value.toDegrees))°")
    }
}
