//
//  ClawControlToggle.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 19.05.2025.
//

import SwiftUI

public struct ClawControlToggle: View {
    @Binding public var clawShouldOpen: Bool

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
