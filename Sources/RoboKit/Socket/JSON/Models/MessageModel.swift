//
//  MessageModel.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 12/05/25.
//

/// Model for the message that the`TCPClient` can send to the `Server`
public struct CPRMessageModel: Codable, Sendable {
    public init(clawControl: Bool, positionAndRotation: [Float]) {
        self.clawControl = clawControl
        self.positionAndRotation = positionAndRotation
    }

    public let clawControl: Bool
    public let positionAndRotation: [Float]
}
