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

/// A SwiftUI view that provides a button for sending data with different modes and visual feedback.
///
/// This view creates an interactive button that can send data in either "live" or "set" modes.
/// The button includes visual feedback with animations, accessibility support, and automatic
/// state management based on the selected data mode.
///
/// ## Usage
/// ```swift
/// @State private var isSendingData = false
/// @State private var selectedDataMode: DataMode = .live
///
/// SendDataButton(
///     onSendLiveData: { /* handle live data sending */ },
///     onSendSetData: { /* handle set data sending */ },
///     isSendingData: $isSendingData,
///     selectedDataMode: $selectedDataMode
/// )
/// ```
public struct SendDataButton: View {
    /// Environment variable to check if motion reduction is enabled for accessibility.
    @Environment(\.accessibilityReduceMotion) var isReduceMotionEnabled
    
    /// Binding to track whether data is currently being sent.
    @Binding private var isSendingData: Bool
    
    /// Binding to the currently selected data transmission mode.
    @Binding var selectedDataMode: DataMode

    /// Closure to execute when sending live data.
    private let onSendLiveData: () -> Void
    
    /// Closure to execute when sending set data.
    private let onSendSetData: () -> Void

    /// Initializes a new send data button view.
    ///
    /// - Parameters:
    ///   - onSendLiveData: Closure to execute when sending live data.
    ///   - onSendSetData: Closure to execute when sending set data.
    ///   - isSendingData: Binding to track the sending state.
    ///   - selectedDataMode: Binding to the selected data transmission mode.
    public init(
        onSendLiveData: @escaping () -> Void,
        onSendSetData: @escaping () -> Void,
        isSendingData: Binding<Bool>,
        selectedDataMode: Binding<DataMode>
    ) {
        self.onSendLiveData = onSendLiveData
        self.onSendSetData = onSendSetData
        self._isSendingData = isSendingData
        _selectedDataMode = selectedDataMode
    }

    /// Creates the button label with dynamic content and animations.
    ///
    /// This computed property creates a horizontal stack containing the main button content
    /// (text and icon) on the left and an optional "Stop" indicator on the right when data
    /// is being sent. It includes animations and accessibility considerations.
    private var buttonLabel: some View {
        let buttonLabel = isSendingData ? "Sending Data" : "Send Data"

        return HStack {
            Label(buttonLabel, systemImage: "sensor.tag.radiowaves.forward")
                .contentTransition(.numericText())
                .symbolEffect(.variableColor, isActive: isSendingData && !isReduceMotionEnabled)
                .animation(isReduceMotionEnabled ? nil : .spring(), value: buttonLabel)

            if isSendingData {
                Text("Stop")
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .background(.gray)
                    .clipShape(.capsule)
                    .padding(.all, 5)
                    .transition(.move(edge: .trailing))
            }
        }
        .frame(height: 44)
        .padding(.leading, 10)
        .padding(.trailing, isSendingData ? 0 : 10)
        .background(.green)
        .clipShape(.capsule)
        .animation(isReduceMotionEnabled ? nil : .spring(), value: isSendingData)
    }

    /// Determines the action to execute based on the selected data mode.
    ///
    /// This computed property returns a closure that handles the button tap action.
    /// For live mode, it toggles the sending state; for set mode, it sends data once
    /// and resets the sending state.
    private var sendAction: () -> Void {
        {
            switch selectedDataMode {
            case .live:
                onSendLiveData()
                isSendingData.toggle()
            case .set:
                onSendSetData()
                isSendingData = false
            }
        }
    }

    public var body: some View {
        Button(action: sendAction) {
            buttonLabel
        }
        .hoverEffectDisabled()
        .buttonStyle(.plain)
        .contentShape(.hoverEffect, .capsule)
        .hoverEffect()

        // Automatically stop sending data when switching away from live mode
        .onChange(of: selectedDataMode) {
            guard selectedDataMode != .live else { return }
            isSendingData = false
        }
    }
}
