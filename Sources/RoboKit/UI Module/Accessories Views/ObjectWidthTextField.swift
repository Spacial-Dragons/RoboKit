//
//  ObjectWidthTextField.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 20.05.2025.
//

import SwiftUI

public struct ObjectWidthTextField: View {
    @Binding public var objectWidth: Float
    
    public init(objectWidth: Binding<Float>) {
        self._objectWidth = objectWidth
    }
    
    public var body: some View {
        TextField("Object Width", value: $objectWidth, format: .number)
            .keyboardType(.numbersAndPunctuation)
            .font(.system(size: 20))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .padding(12)
            )
            .frame(width: 200)
    }
}
