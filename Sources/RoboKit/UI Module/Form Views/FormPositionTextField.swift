//
//  FormPositionTextField.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 20.05.2025.
//

import SwiftUI

public struct FormPositionTextField: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let axis: Axis
    
    public init(axis: Axis) {
        self.axis = axis
    }
    
    private var positionValue: Binding<Float> {
        Binding(
            get: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRoot.x
                case .longitudinal:
                    formManager.formPositionRelativeToRoot.y
                case .vertical:
                    formManager.formPositionRelativeToRoot.z
                }
            },
            set: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRoot.x = $0
                case .longitudinal:
                    formManager.formPositionRelativeToRoot.y = $0
                case .vertical:
                    formManager.formPositionRelativeToRoot.z = $0
                }
            }
        )
    }
    
    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }
    
    public var body: some View {
        HStack {
            Text("\(axisLabel)")
            
            TextField("Position \(axisLabel)", value: positionValue, format: .number)
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
