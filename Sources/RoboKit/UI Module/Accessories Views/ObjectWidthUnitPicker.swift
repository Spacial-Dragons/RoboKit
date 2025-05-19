//
//  ObjectWidthUnitPicker.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 19.05.2025.
//

import SwiftUI

public struct ObjectWidthUnitPicker: View {

    @Binding public var objectWidthUnit: ObjectWidthUnit

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
            .padding()
    }
}
