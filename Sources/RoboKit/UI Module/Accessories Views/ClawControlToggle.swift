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

public struct ClawControlToggle: View {
    @Binding private var clawShouldOpen: Bool

    public init(clawShouldOpen: Binding<Bool>) {
        self._clawShouldOpen = clawShouldOpen
    }

    public var body: some View {
        Picker("Claw Control", selection: $clawShouldOpen) {
            Text("Open").tag(true)
            Text("Close").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
