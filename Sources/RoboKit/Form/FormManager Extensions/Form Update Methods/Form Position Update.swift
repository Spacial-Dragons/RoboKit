//
//  Form Position Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 24.05.2025.
//

extension FormManager {

    public func updateFormPosition() {
        formPositionRelativeToRoot = formPositionRelativeToRootROS.convertToRealityKitCoordinateSystem()
    }
}
