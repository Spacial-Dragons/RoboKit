//
//  InputSphereRotationSlider.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import SwiftUI

public struct InputSphereRotationSlider: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let eulerAngle: EulerAngle
    let maxValue: Float = 180
    let minValue: Float = -180
    let step: Float = 1

    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }
    
    /// Retrieves the appropriate binding for the selected Euler angle.
    private var angleValue: Binding<Float> {
        Binding(
            get: { inputSphereManager.inputSphereEulerAngles[eulerAngle] ?? 0 },
            set: { inputSphereManager.inputSphereEulerAngles[eulerAngle] = $0 }
        )
    }

    private var angleLabel: String {
        switch eulerAngle {
        case .roll: return "Roll"
        case .yaw: return "Yaw"
        case .pitch: return "Pitch"
        }
    }

    public var body: some View {
        VStack {
            // Displays the current angle value in degrees
            Text("\(Int(angleValue.wrappedValue.toDegrees))°")
                .padding(.leading, 50)
            
            // Slider with labels
            VStack(alignment: .leading) {
                HStack {
                    Text("\(angleLabel):")
                    Text("\(String(format: "%.0f", minValue))°")
                    Slider(value: angleValue, in: (minValue.toRadians)...(maxValue.toRadians), step: step.toRadians)
                    Text("\(String(format: "%.0f", maxValue))°")
                }
            }
        }
    }
}
