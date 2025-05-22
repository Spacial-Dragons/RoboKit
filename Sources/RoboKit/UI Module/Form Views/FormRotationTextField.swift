//
//  FormRotationTextField.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 22.05.2025.
//

import SwiftUI

public struct FormRotationTextField: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let eulerAngle: EulerAngle
    
    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }
    
    /// Retrieves the appropriate binding for the selected Euler angle from the manager.
    private var angleValue: Binding<Float> {
        Binding(
            get: { formManager.formEulerAngles[eulerAngle] ?? 0 },
            set: { formManager.formEulerAngles[eulerAngle] = $0 }
        )
    }
    
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
            
            TextField("Rotation \(axisLabel)", value: angleValue, format: .number)
                .keyboardType(.numbersAndPunctuation)
                .font(.system(size: 20))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .padding(12)
                )
        }
    }
}
