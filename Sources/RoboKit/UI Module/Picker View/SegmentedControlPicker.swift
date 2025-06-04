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

public struct SegmentedControlItem: Identifiable {
    public var id: UUID = UUID()
    public var label: String
    public var accessibilityLabel: Text?

    public init(label: String, accessibilityLabel: Text? = nil) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
    }
}

public struct SegmentedControlPicker: View {
    let items: [SegmentedControlItem]
    let accessibilityLabel: Text?
    @Binding var selectedIndex: Int

    public init(items: [SegmentedControlItem], selectedIndex: Binding<Int>, accessibilityLabel: Text? = nil) {
        self.items = items
        _selectedIndex = selectedIndex
        self.accessibilityLabel = accessibilityLabel

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
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Text(item.label)
                    .tag(index)
                    .accessibilityLabel(item.accessibilityLabel ?? Text(""), isEnabled: item.accessibilityLabel != nil)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel(accessibilityLabel ?? Text(""), isEnabled: accessibilityLabel != nil)
    }
}
