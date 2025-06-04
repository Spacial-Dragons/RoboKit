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
    @Environment(TCPClient.self) private var client: TCPClient

    public init() {}

    public var body: some View {
        @Bindable var client = client

        let options: [SegmentedControlItem] = DataMode.allCases.map {
            SegmentedControlItem(label: $0.rawValue)
        }
        let selectedIndex = Binding<Int>(
            get: { DataMode.allCases.firstIndex(of: client.selectedDataMode) ?? 0 },
            set: { client.selectedDataMode = DataMode.allCases[$0] }
        )

        SegmentedControlPicker(
            items: options,
            selectedIndex: selectedIndex,
            accessibilityLabel: Text("Data Transmission Mode")
        )
    }
}
