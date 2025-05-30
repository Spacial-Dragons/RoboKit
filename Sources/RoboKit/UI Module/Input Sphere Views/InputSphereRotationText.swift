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

public struct InputSphereRotationText: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    private let eulerAngle: EulerAngle

    public init(eulerAngle: EulerAngle) {
        self.eulerAngle = eulerAngle
    }

    private var angleValue: Float? {
        inputSphereManager.inputSphereEulerAngles[eulerAngle]?.toDegrees ?? 0
    }

    private var axisLabel: String {
        switch eulerAngle {
        case .pitch: return "X"
        case .yaw: return "Y"
        case .roll: return "Z"
        }
    }

    public var body: some View {
        HStack(spacing: 20) {
            Text(axisLabel)
            Text(angleValue.map { String(format: "%.0f°", $0) } ?? "NA")
                .frame(width: 50)
        }
    }
}
