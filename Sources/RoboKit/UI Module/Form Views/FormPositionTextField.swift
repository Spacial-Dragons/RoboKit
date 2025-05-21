//
//  FormPositionTextField.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 20.05.2025.
//

import SwiftUI

public struct FormPositionTextField: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let formAxis: RoboKit.FormAxis
    
    public init(formAxis: FormAxis) {
        self.formAxis = formAxis
    }
    
    private var positionValue: Binding<Float> {
        Binding(
            get: {
                switch formAxis {
                case .lateral:
                    formManager.formPositionRelativeToRoot.x
                case .longitudinal:
                    formManager.formPositionRelativeToRoot.y
                case .vertical:
                    formManager.formPositionRelativeToRoot.z
                }
            },
            set: {
                switch formAxis {
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
    
    private var formAxisLabel: String {
        switch formAxis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }
    
    public var body: some View {
        HStack {
            Text("\(formAxisLabel)")
            
            TextField("Position \(formAxisLabel)", value: positionValue, format: .number)
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
