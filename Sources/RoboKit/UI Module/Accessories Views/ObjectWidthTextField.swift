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

<<<<<<< HEAD
/// A SwiftUI view that provides an editable text field for object width values.
///
/// This view creates a text field that allows users to input and edit object width values.
/// The text field uses a capsule style for consistent appearance with the RoboKit design system
/// and includes number input validation.
///
/// ## Usage
/// ```swift
/// @State private var objectWidth: Float = 10.0
/// ObjectWidthTextField(objectWidth: $objectWidth)
/// ```
public struct ObjectWidthTextField: View {
    /// Binding to the object width value.
    @Binding private var objectWidth: Float

    /// Initializes a new object width text field view.
    ///
    /// - Parameter objectWidth: Binding to the object width value to be edited.
=======
public struct ObjectWidthTextField: View {
    @Binding private var objectWidth: Float

>>>>>>> main
    public init(objectWidth: Binding<Float>) {
        self._objectWidth = objectWidth
    }

    public var body: some View {
        TextField("Object Width", value: $objectWidth, format: .number)
            .keyboardType(.numbersAndPunctuation)
            .textFieldStyle(CapsuleTextFieldStyle())
            .frame(width: 200)
    }
}
