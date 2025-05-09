//
//  EulerAngle.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 01.05.2025.
//

/// An enumeration that defines the three principal Euler angles used to describe orientation in 3D space: roll, yaw, and pitch.
///
/// Use `EulerAngle` to represent the axis of rotation in contexts such as robotics, animation, or 3D graphics.
/// This enum is especially useful when working across coordinate systems like ROS and RealityKit, where axis mappings differ.
public enum EulerAngle {
    
    /// Rotation around the longitudinal axis — the x-axis in both ROS and RealityKit coordinate systems. Commonly referred to as *roll*.
    case roll
    
    /// Rotation around the vertical axis — the z-axis in ROS and the y-axis in RealityKit. Commonly referred to as *yaw*.
    case yaw
    
    /// Rotation around the lateral axis — the y-axis in ROS and the z-axis in RealityKit. Commonly referred to as *pitch*.
    case pitch
}
