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

public struct FormRotationTextField: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let eulerAngle: EulerAngle

    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }

    /// Retrieves the appropriate binding for the selected Euler angle from the manager.
    private var angleValue: Binding<Float> {
        Binding(
            get: { formManager.formEulerAngles[eulerAngle] ?? 0 },
            set: { formManager.formEulerAngles[eulerAngle] = $0 }
        )
    }

    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return "Rotation X"
        case .yaw: return "Rotation Y"
        case .roll: return "Rotation Z"
        }
    }

    public var body: some View {
        HStack {
            Text("\(axisLabel)")

            TextField("", value: angleValue, format: .number)
                .keyboardType(.numbersAndPunctuation)
                .font(.system(size: 20))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .padding(12)
                )
        }
    }
}
