//
//  Data Mode Toggle.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 19.05.2025.
//

import SwiftUI

public struct DataModeToggle: View {
    @Environment(TCPClient.self) private var client: TCPClient
    
    public init() {
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(Color(.pickerBlue))
        ]
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        let appearance = UISegmentedControl.appearance()
        appearance.setTitleTextAttributes(normalTextAttributes, for: .normal)
        appearance.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        appearance.selectedSegmentTintColor = .white
    }
    
    public var body: some View {
        @Bindable var client = client
        
        Picker("", selection: $client.selectedDataMode) {
            ForEach(DataMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
