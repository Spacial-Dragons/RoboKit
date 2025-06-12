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

/// A SwiftUI view that provides a picker for selecting data transmission modes.
///
/// This view creates a segmented control that allows users to select between different
/// data transmission modes (e.g., "live" and "set"). The picker uses the `SegmentedControlPicker`
/// component for consistent styling and includes accessibility support.
///
/// ## Usage
/// ```swift
/// @State private var selectedDataMode: DataMode = .live
/// DataModePicker(selectedDataMode: $selectedDataMode)
/// ```
public struct DataModePicker: View {
    /// Binding to the selected data transmission mode.
    @Binding var selectedDataMode: DataMode

    /// Initializes a new data mode picker view.
    ///
    /// - Parameter selectedDataMode: Binding to the selected data transmission mode.
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
