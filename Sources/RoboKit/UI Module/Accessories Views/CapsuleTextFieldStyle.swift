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

/// A custom text field style that provides a capsule-shaped appearance with hover effects.
///
/// This text field style creates a rounded, capsule-shaped text field with a material
/// background and interactive hover effects. It's designed to provide a modern, consistent
/// appearance across the RoboKit application.
///
/// ## Usage
/// ```swift
/// TextField("Enter text", text: $text)
///     .textFieldStyle(CapsuleTextFieldStyle())
/// ```
struct CapsuleTextFieldStyle: TextFieldStyle {
    /// Creates the body of the text field with capsule styling.
    ///
    /// This method applies the capsule shape, material background, padding, and hover effects
    /// to create a consistent text field appearance throughout the application.
    ///
    /// - Parameter configuration: The text field configuration containing the text field content.
    /// - Returns: A view with the applied capsule text field styling.
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .hoverEffectDisabled()
            .padding(4)
            .padding(.leading, 4)
            .background(.regularMaterial)
            .clipShape(.capsule)
            .contentShape(.hoverEffect, .capsule)
            .hoverEffect()
    }
}
