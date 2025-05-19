//
//  SegmentedControlPicker.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 19.05.2025.
//

import SwiftUI

public struct SegmentedControlPicker: UIViewRepresentable {
    let items: [String]
    @Binding var selectedIndex: Int

    public func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: items)

        control.selectedSegmentTintColor = .white

        control.setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .normal)

        control.setTitleTextAttributes([
            .foregroundColor: UIColor(Color(.pickerBlue))
        ], for: .selected)

        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.selectionChanged(_:)),
            for: .valueChanged
        )
        control.selectedSegmentIndex = selectedIndex
        return control
    }

    public func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = selectedIndex
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject {
        var parent: SegmentedControlPicker

        init(_ parent: SegmentedControlPicker) {
            self.parent = parent
        }

        @MainActor @objc func selectionChanged(_ sender: UISegmentedControl) {
            parent.selectedIndex = sender.selectedSegmentIndex
        }
    }
}
