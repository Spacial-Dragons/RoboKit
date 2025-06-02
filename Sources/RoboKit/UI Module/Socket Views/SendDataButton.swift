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

public struct SendDataButton: View {
    @Environment(TCPClient.self) private var client: TCPClient
    @State private var isSendingData: Bool = false

    private let onSendLiveData: () -> Void
    private let onSendSetData: () -> Void

    public init(
        onSendLiveData: @escaping () -> Void,
        onSendSetData: @escaping () -> Void
    ) {
        self.onSendLiveData = onSendLiveData
        self.onSendSetData = onSendSetData
    }

    // Label now wraps an HStack: the original text+icon on the left, and a gray capsule on the right
    private var buttonLabel: some View {
        let buttonLabel = isSendingData ? "Sending Data" : "Send Data"

        return HStack {
            Label(buttonLabel, systemImage: "sensor.tag.radiowaves.forward")
                .contentTransition(.numericText())
                .symbolEffect(.variableColor, isActive: isSendingData)
                .animation(.spring, value: buttonLabel)

            if isSendingData {
                Text("Stop")
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .background(.gray)
                    .clipShape(.capsule)
                    .padding(.all, 5)
            }
        }
        .frame(height: 44)
        .padding(.leading, 10)
        .padding(.trailing, isSendingData ? 0 : 10)
        .background(.green)
        .clipShape(.capsule)
    }

    private var sendAction: () -> Void {
        {
            switch client.selectedDataMode {
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

        // Stop Sending Data after Data Mode switches off
        .onChange(of: client.selectedDataMode) {
            guard client.selectedDataMode != .live else { return }
            isSendingData = false
        }
    }
}
