# Input Entity

@Metadata {
    @PageImage(purpose: card, source: "InputEntityCard", alt: "Input Entity Card")
}

The Input Entity module provides a visual and interactive way to control a robot's end effector in 3D space using visionOS.

## Overview

The Input Entity module creates a virtual object that can be positioned and rotated in 3D space to represent the desired pose (position and orientation) of a robot's end effector. This module provides coordinate transformations between visionOS (RealityKit) and ROS (Robot Operating System) coordinate systems, making it easy to integrate with robotic applications.

## Setup

### Initialize Input Entity Manager

Create an instance of the ``InputEntityManager`` to track and update the position and orientation of the Input Entity:

```swift
import RoboKit

@State private var inputEntityManager = InputEntityManager()
```

### Add Input Entity to RealityKit Scene

Add the Input Entity to your RealityKit scene with the appropriate parent and rootPoint entities:

```swift
.onAppear {
    inputEntityManager.addInputEntity(parentEntity: parentEntity, rootPoint: rootPoint)
}
```

## Usage

### Control Input Entity Position

Update the position of the Input Entity using a drag gesture:

```swift
// Add Input Entity Drag Gesture recognition and handling.
.inputEntityDragGesture(
    parentEntity: parentEntity,
    rootPoint: rootPoint,
    inputEntityManager: inputEntityManager
)
```

### Control Input Entity Orientation

Update the orientation of the Input Entity using Euler angles:

```swift
// Set orientation using roll, pitch, and yaw
inputEntityManager.inputEntityEulerAngles = [
    .roll: Float.pi / 4,   // 45 degrees
    .yaw: 0,
    .pitch: Float.pi / 6   // 30 degrees
]
```

### Track Input Entity Position

Monitor the position of the Input Entity relative to a root point in your scene:

```swift
// Get position in ROS coordinate system
if let position = inputEntityManager.getInputEntityPosition(relativeToRootPoint: rootEntity) {
    print("Input Entity position (ROS): \(position)")
}
```

### Track Input Entity Orientation

Monitor the orientation of the Input Entity relative to a root point in your scene:

```swift
// Get position in ROS coordinate system
if let orientation = inputEntityManager.getInputEntityRotation(relativeToRootPoint: rootEntity) {
    print("Input Entity orientation (ROS): \(orientation)")
}
```

### Display Input Entity Data

Add the ``InputEntityPositionView`` to your SwiftUI interface to display the current position:

```swift
InputEntityPositionView(relativeToRootPoint: rootEntity)
```

### Enable Interactive Control

Allow users to adjust the Input Entity using the rotation sliders:

```swift
VStack {
    InputEntityRotationSlider(eulerAngle: .roll)
    InputEntityRotationSlider(eulerAngle: .pitch)
    InputEntityRotationSlider(eulerAngle: .yaw)
}
```

> Important: Remember that the Input Entity uses different coordinate systems for RealityKit and ROS. Position and rotation values are automatically converted when using the appropriate getter methods.
