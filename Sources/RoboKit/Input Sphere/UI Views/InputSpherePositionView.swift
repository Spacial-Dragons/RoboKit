//
//  InputSpherePositionView.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import SwiftUI

public struct InputSpherePositionView: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    private var positionString: String { return inputSphereManager.inputSpherePositionString() }
    
    public init() {}
    
    public var body: some View {
        Text(positionString)
    }
}
