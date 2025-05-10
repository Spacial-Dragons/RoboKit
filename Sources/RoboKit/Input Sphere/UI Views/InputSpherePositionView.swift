//
//  InputSpherePositionView.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit
import SwiftUI

/// A SwiftUI view that displays the position of the Input Sphere relative to a specified root point.
///
/// `InputSpherePositionView` queries the `InputSphereManager` from the environment and shows the
/// Input Sphere's position in the ROS coordinate system. If the position is unavailable, it displays `"NA"`.
///
/// ```swift
/// InputSpherePositionView(relativeToRootPoint: someRootEntity)
/// ```
///
/// - Note: The position string is automatically updated based on the current state of the `InputSphereManager`.
public struct InputSpherePositionView: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let rootPoint: Entity
    
    /// The formatted position string of the Input Sphere relative to the root point.
    private var positionString: String? {
        return inputSphereManager.inputSpherePositionString(relativeToRootPoint: rootPoint)
    }

    /// Creates a view that displays the Input Sphere's position relative to a given root point.
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
