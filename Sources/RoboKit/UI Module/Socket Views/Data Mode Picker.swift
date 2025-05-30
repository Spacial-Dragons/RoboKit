//
//  Data Mode Picker.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 19.05.2025.
//

import SwiftUI

public struct DataModePicker: View {
    @Environment(TCPClient.self) private var client: TCPClient

    public init() {}

    public var body: some View {
        @Bindable var client = client

        let options = DataMode.allCases.map { $0.rawValue }
        let selectedIndex = Binding<Int>(
            get: { DataMode.allCases.firstIndex(of: client.selectedDataMode) ?? 0 },
            set: { client.selectedDataMode = DataMode.allCases[$0] }
        )

        SegmentedControlPicker(items: options, selectedIndex: selectedIndex)
    }
}
