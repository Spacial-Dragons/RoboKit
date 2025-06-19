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

/// A SwiftUI view that displays the position of the Input Entity relative to a specified root point.
///
/// `InputEntityPositionView` queries the `InputEntityManager` from the environment and shows the
/// Input Entity's position in the ROS coordinate system. If the position is unavailable, it displays `"NA"`.
///
/// ```swift
/// InputEntityPositionView(relativeToRootPoint: someRootEntity)
/// ```
///
/// - Note: The position string is automatically updated based on the current state of the `InputEntityManager`.
public struct InputEntityPositionView: View {
    @Environment(InputEntityManager.self) private var inputEntityManager: InputEntityManager
    let rootPoint: Entity

    /// The formatted position string of the Input Entity relative to the root point.
    private var positionString: String? {
        return inputEntityManager.inputEntityPositionString(relativeToRootPoint: rootPoint)
    }

    /// Creates a view that displays the Input Entity's position relative to a given root point.
    ///
    /// - Parameter rootPoint: The reference entity for calculating the relative position.
    public init(relativeToRootPoint rootPoint: Entity) {
        self.rootPoint = rootPoint
    }

    /// The content and behavior of the view.
    public var body: some View {
        Text(positionString ?? "NA")
    }
}
