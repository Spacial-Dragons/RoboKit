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

public struct InputSpherePositionText: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    private let axis: Axis
    private let showFullDescription: Bool

    public init(axis: Axis, showFullDescription: Bool = false) {
        self.axis = axis
        self.showFullDescription = showFullDescription
    }

    private var positionValue: Float? {
        guard let position = inputSphereManager.inputSpherePositionRelativeToRoot
        else { return nil }
        let positionInROS = position.convertToROSCoordinateSystem()

        switch axis {
        case .lateral: return positionInROS.x
        case .longitudinal: return positionInROS.y
        case .vertical: return positionInROS.z
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
        HStack {
            if showFullDescription {
                Text("Position \(axisLabel)")
            } else {
                Text(axisLabel)
            }
            Text(positionValue.map { String(format: "%.3f", $0) } ?? "NA")
                .foregroundStyle(.secondary)
                .fontDesign(.monospaced)
        }
    }
}
