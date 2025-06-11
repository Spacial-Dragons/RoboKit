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
/// A SwiftUI view that provides a picker for selecting object width units.
///
/// This view creates a segmented control that allows users to select from different
/// units of measurement for object width (millimeters, centimeters, or meters).
/// The picker uses the `SegmentedControlPicker` component for consistent styling
/// and includes accessibility support.
///
/// ## Usage
/// ```swift
/// @State private var objectWidthUnit: ObjectWidthUnit = .millimeters
/// ObjectWidthUnitPicker(objectWidthUnit: $objectWidthUnit)
/// ```
public struct ObjectWidthUnitPicker: View {
    /// Binding to the selected object width unit.
    @Binding private var objectWidthUnit: ObjectWidthUnit

    /// Initializes a new object width unit picker view.
    ///
    /// - Parameter objectWidthUnit: Binding to the selected object width unit.
=======
public struct ObjectWidthUnitPicker: View {

    @Binding private var objectWidthUnit: ObjectWidthUnit

>>>>>>> main
    public init(objectWidthUnit: Binding<ObjectWidthUnit>) {
        self._objectWidthUnit = objectWidthUnit
    }

    public var body: some View {
        let options: [SegmentedControlItem] = ObjectWidthUnit.allCases.map {
            SegmentedControlItem(label: $0.rawValue, accessibilityLabel: Text($0.accessibilityDescription))
        }
        let selectedIndex = Binding<Int>(
            get: { ObjectWidthUnit.allCases.firstIndex(of: objectWidthUnit) ?? 0 },
            set: { objectWidthUnit = ObjectWidthUnit.allCases[$0] }
        )

        SegmentedControlPicker(
            items: options,
            selectedIndex: selectedIndex,
            accessibilityLabel: Text("Object Width Unit")
        )
    }
}
