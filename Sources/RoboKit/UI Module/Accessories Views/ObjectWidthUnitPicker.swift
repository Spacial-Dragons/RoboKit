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

public struct ObjectWidthUnitPicker: View {

    @Binding private var objectWidthUnit: ObjectWidthUnit

    public init(objectWidthUnit: Binding<ObjectWidthUnit>) {
        self._objectWidthUnit = objectWidthUnit
    }

    public var body: some View {
        let options = ObjectWidthUnit.allCases.map { $0.rawValue }
        let selectedIndex = Binding<Int>(
            get: { ObjectWidthUnit.allCases.firstIndex(of: objectWidthUnit) ?? 0 },
            set: { objectWidthUnit = ObjectWidthUnit.allCases[$0] }
        )

        SegmentedControlPicker(items: options, selectedIndex: selectedIndex)
    }
}
