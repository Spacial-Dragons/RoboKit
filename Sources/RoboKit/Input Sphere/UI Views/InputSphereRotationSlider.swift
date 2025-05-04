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

    /// Retrieves the appropriate binding for the selected Euler angle.
    private var rotationValue: Binding<Float> {
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
            Text("\(Int(rotationValue.wrappedValue * 180 / .pi))°")
                .padding(.leading, 50)
            
            // Slider with labels
            VStack(alignment: .leading) {
                HStack {
                    Text("\(angleLabel):")
                    Text("-180°")
                    Slider(value: rotationValue, in: (-1 * .pi)...(.pi), step: 2 * .pi / 360)
                        .frame(width: 400)
                    Text("180°")
                }
            }
        }
    }
}
