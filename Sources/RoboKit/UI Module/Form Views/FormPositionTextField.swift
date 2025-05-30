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

public struct FormPositionTextField: View {
    @Environment(FormManager.self) private var formManager: FormManager
    private let axis: Axis

    public init(axis: Axis) {
        self.axis = axis
    }

    // ROS system
    private var positionValue: Binding<Float> {
        Binding(
            get: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRootROS.x
                case .longitudinal:
                    formManager.formPositionRelativeToRootROS.y
                case .vertical:
                    formManager.formPositionRelativeToRootROS.z
                }
            },
            set: {
                switch axis {
                case .lateral:
                    formManager.formPositionRelativeToRootROS.x = $0
                case .longitudinal:
                    formManager.formPositionRelativeToRootROS.y = $0
                case .vertical:
                    formManager.formPositionRelativeToRootROS.z = $0
                }
            }
        )
    }

    // ROS Labels
    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }

    public var body: some View {
        HStack {
            Text("\(axisLabel)")

            TextField("", value: positionValue, format: .number)
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
