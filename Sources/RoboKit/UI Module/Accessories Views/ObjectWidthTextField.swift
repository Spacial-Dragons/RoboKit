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

public struct ObjectWidthTextField: View {
    @Binding private var objectWidth: Float

    public init(objectWidth: Binding<Float>) {
        self._objectWidth = objectWidth
    }

    public var body: some View {
        TextField("Object Width", value: $objectWidth, format: .number)
            .keyboardType(.numbersAndPunctuation)
            .font(.title3)
            .textFieldStyle(CapsuleTextFieldStyle())
            .frame(width: 200)
    }
}
