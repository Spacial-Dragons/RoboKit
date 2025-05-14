# Image Tracker

The Image Tracker module provides functionality for detecting and tracking images in the physical environment using ARKit and visionOS.

## Overview
This module leverages ARKit to track one or more reference images added to an AR Resource Group in your asset catalog. It exposes two main properties: `rootTransform`, which represents the calculated center of all tracked images, and `trackedImagesTransform`, which represents the positions of each individual image.

## Setup

### Configure Permissions
Add the following key to your app’s Info.plist file:
```xml
<key>NSWorldSensingUsageDescription</key>
<string>This app requires world sensing capabilities to track reference images.</string>
```

### Create AR Reference Image Group
- Open Xcode and go to your asset catalog.
- Add a new **AR Resource Group** (e.g., "AR Resources").
- Add your tracking images and set their **physical size** correctly.

### Define Tracking Images in Code
Each image should be described using its name and a root offset from the reference point in RealityKit coordinates:

```swift
import RoboKit

let trackingImages: [TrackingImage] = [
    TrackingImage(imageName: "TrackingImage-1", rootOffset: .init(x: -0.1135, y: 0, z: 0.175)),
    TrackingImage(imageName: "TrackingImage-2", rootOffset: .init(x: 0.1135, y: 0, z: -0.175))
]
```

![RealityKit coordinate system](RealityKit-Coordinate-System.png)

> Important: Tracking image quality is critical. Avoid compressed images, images with too few or too many geometric features, or with repeating patterns.

> Important: Ensure all tracking images share the same physical orientation.

> Note: If using multiple images, the `rootOffset` values are used to calculate the center. If using one image, set its offset to `.zero`.

### Initialize Image Tracker
Initialize the ``ImageTracker`` by providing the resource group name and your array of tracking images:

```swift
@State private var imageTracker: RoboKit.ImageTracker = .init(
    arResourceGroupName: "AR Resources",
    images: trackingImages
)
```

## Usage

### Root Transform
Represents the central position between all tracked images.
```swift
.onChange(of: imageTracker.rootTransform) {
    print(imageTracker.rootTransform)
}
```

### Tracked Images Transform
Represents the positions of each tracked image:
```swift
.onChange(of: imageTracker.trackedImagesTransform) {
    print(imageTracker.trackedImagesTransform)
}
```

> Note: These values update approximately once per second.

> Warning: Image tracking is not supported in the simulator.

> Important: On visionOS, only one image can be tracked at a time, even if more are visible.
