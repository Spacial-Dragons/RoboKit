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

struct CapsuleTextFieldStyle: TextFieldStyle {
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(4)
            .padding(.leading, 4)
            .background(.regularMaterial)
            .clipShape(.capsule)
    }
}
