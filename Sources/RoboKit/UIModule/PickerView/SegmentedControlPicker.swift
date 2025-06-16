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

/// A data structure representing an item in a segmented control picker.
///
/// This struct provides a standardized way to define segments in a segmented control,
/// including both display labels and accessibility information.
public struct SegmentedControlItem: Identifiable {
    /// A unique identifier for the segment item.
    public var id: UUID = UUID()

    /// The text label displayed for this segment.
    public var label: String

    /// Optional accessibility label for screen readers and accessibility features.
    public var accessibilityLabel: Text?

    /// Initializes a new segmented control item.
    ///
    /// - Parameters:
    ///   - label: The text label to display for this segment.
    ///   - accessibilityLabel: Optional accessibility label for screen readers.
    public init(label: String, accessibilityLabel: Text? = nil) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
    }
}

/// A customizable segmented control picker component for SwiftUI.
///
/// This view provides a segmented control interface that can be used to select
/// from multiple options. It includes built-in styling that matches the RoboKit
/// design system and comprehensive accessibility support.
///
/// ## Usage
/// ```swift
/// let items = [
///     SegmentedControlItem(label: "Option 1"),
///     SegmentedControlItem(label: "Option 2")
/// ]
/// @State private var selectedIndex = 0
///
/// SegmentedControlPicker(
///     items: items,
///     selectedIndex: $selectedIndex,
///     accessibilityLabel: Text("Choose an option")
/// )
/// ```
public struct SegmentedControlPicker: View {
    /// The array of segment items to display in the picker.
    let items: [SegmentedControlItem]

    /// Optional accessibility label for the entire picker component.
    let accessibilityLabel: Text?

    /// Binding to the currently selected segment index.
    @Binding var selectedIndex: Int

    /// Initializes a new segmented control picker.
    ///
    /// - Parameters:
    ///   - items: Array of segment items to display.
    ///   - selectedIndex: Binding to track the selected segment index.
    ///   - accessibilityLabel: Optional accessibility label for the entire picker.
    ///
    /// This initializer also configures the global appearance of UISegmentedControl
    /// to match the RoboKit design system with white background for selected segments
    /// and blue text for selected items.
    public init(items: [SegmentedControlItem], selectedIndex: Binding<Int>, accessibilityLabel: Text? = nil) {
        self.items = items
        _selectedIndex = selectedIndex
        self.accessibilityLabel = accessibilityLabel

        // Configure global appearance to match RoboKit design system
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
