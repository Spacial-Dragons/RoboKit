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
/// A SwiftUI view that provides a toggle control for claw operations.
///
/// This view creates a segmented control that allows users to switch between "Close"
/// and "Open" states for a robotic claw. The control uses a segmented picker style
/// for intuitive operation.
///
/// ## Usage
/// ```swift
/// @State private var clawShouldOpen = false
/// ClawControlToggle(clawShouldOpen: $clawShouldOpen)
/// ```
public struct ClawControlToggle: View {
    /// Binding to the claw state - true for closed, false for open.
    @Binding private var clawShouldOpen: Bool

    /// Initializes a new claw control toggle view.
    ///
    /// - Parameter clawShouldOpen: Binding to control the claw state where true represents
    ///                             closed and false represents open.
=======
public struct ClawControlToggle: View {
    @Binding private var clawShouldOpen: Bool

>>>>>>> main
    public init(clawShouldOpen: Binding<Bool>) {
        self._clawShouldOpen = clawShouldOpen
    }

    public var body: some View {
        Picker("Claw Control", selection: $clawShouldOpen) {
            Text("Close").tag(true)
            Text("Open").tag(false)
        }
        .pickerStyle(.segmented)
    }
}
