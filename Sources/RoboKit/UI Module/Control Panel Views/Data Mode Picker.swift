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

public struct DataModePicker: View {
    @Binding var selectedDataMode: DataMode

    public init(selectedDataMode: Binding<DataMode>) {
        _selectedDataMode = selectedDataMode
    }

    public var body: some View {
        let options: [SegmentedControlItem] = DataMode.allCases.map {
            SegmentedControlItem(label: $0.rawValue)
        }
        let selectedIndex = Binding<Int>(
            get: { DataMode.allCases.firstIndex(of: selectedDataMode) ?? 0 },
            set: { selectedDataMode = DataMode.allCases[$0] }
        )

        SegmentedControlPicker(
            items: options,
            selectedIndex: selectedIndex,
            accessibilityLabel: Text("Data Transmission Mode")
        )
    }
}
