# Input Sphere

@Metadata {
    @PageImage(purpose: card, source: "InputSphereCard", alt: "Input Sphere Card")
}

The Input Sphere module provides a visual and interactive way to control a robot's end effector in 3D space using visionOS.

## Overview

The Input Sphere module creates a virtual sphere that can be positioned and rotated in 3D space to represent the desired pose (position and orientation) of a robot's end effector. This module provides coordinate transformations between visionOS (RealityKit) and ROS (Robot Operating System) coordinate systems, making it easy to integrate with robotic applications.

## Setup

### Initialize Input Sphere Manager

Create an instance of the ``InputSphereManager`` to track and update the position and orientation of the Input Sphere:

```swift
import RoboKit

@State private var inputSphereManager = InputSphereManager()
```

### Add Input Sphere to RealityKit Scene

Add the Input Sphere to your RealityKit scene with the appropriate parent and rootPoint entities:

```swift
.onAppear {
    inputSphereManager.addInputSphere(parentEntity: parentEntity, rootPoint: rootPoint)
}
```

## Usage

### Control Input Sphere Position

Update the position of the Input Sphere using a drag gesture:

```swift
// Add Input Sphere Drag Gesture recognition and handling.
.inputSphereDragGesture(
    parentEntity: parentEntity,
    rootPoint: rootPoint,
    inputSphereManager: inputSphereManager
)
```

### Control Input Sphere Orientation

Update the orientation of the Input Sphere using Euler angles:

```swift
// Set orientation using roll, pitch, and yaw
inputSphereManager.inputSphereEulerAngles = [
    .roll: Float.pi / 4,   // 45 degrees
    .yaw: 0,
    .pitch: Float.pi / 6   // 30 degrees
]
```

### Track Input Sphere Position

Monitor the position of the Input Sphere relative to a root point in your scene:

```swift
// Get position in ROS coordinate system
if let position = inputSphereManager.getInputSpherePosition(relativeToRootPoint: rootEntity) {
    print("Input Sphere position (ROS): \(position)")
}
```

### Track Input Sphere Orientation

Monitor the orientation of the Input Sphere relative to a root point in your scene:

```swift
// Get position in ROS coordinate system
if let orientation = inputSphereManager.getInputSphereRotation(relativeToRootPoint: rootEntity) {
    print("Input Sphere orientation (ROS): \(orientation)")
}
```

### Display Input Sphere Data

Add the ``InputSpherePositionView`` to your SwiftUI interface to display the current position:

```swift
InputSpherePositionView(relativeToRootPoint: rootEntity)
```

### Enable Interactive Control

Allow users to adjust the Input Sphere using the rotation sliders:

```swift
VStack {
    InputSphereRotationSlider(eulerAngle: .roll)
    InputSphereRotationSlider(eulerAngle: .pitch)
    InputSphereRotationSlider(eulerAngle: .yaw)
}
```

> Important: Remember that the Input Sphere uses different coordinate systems for RealityKit and ROS. Position and rotation values are automatically converted when using the appropriate getter methods.
