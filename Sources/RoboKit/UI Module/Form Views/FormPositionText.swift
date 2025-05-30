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

import RealityKit
import SwiftUI

public struct FormPositionText: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let axis: Axis
    private let valueWidth: CGFloat

    public init(axis: Axis, valueWidth: CGFloat = 60) {
        self.axis = axis
        self.valueWidth = valueWidth
    }

    private var positionValue: Float? {
        let position = formManager.formPositionRelativeToRootROS

        switch axis {
        case .lateral: return position.x
        case .longitudinal: return position.y
        case .vertical: return position.z
        }
    }

    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }

    public var body: some View {
        HStack(spacing: 20) {
            Text(axisLabel)
            Text(positionValue.map { String(format: "%.3f", $0) } ?? "NA")
                .frame(width: valueWidth)
        }
    }
}
