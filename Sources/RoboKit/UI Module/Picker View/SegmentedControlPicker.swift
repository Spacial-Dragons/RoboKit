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

public struct SegmentedControlPicker: View {
    let items: [String]
    @Binding var selectedIndex: Int

    public init(items: [String], selectedIndex: Binding<Int>) {
        self.items = items
        _selectedIndex = selectedIndex

        // global appearance
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color(.pickerBlue))],
            for: .selected
        )
    }

    public var body: some View {
        Picker("", selection: $selectedIndex) {
            ForEach(items.indices, id: \.self) { index in
                Text(items[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
    }
}
