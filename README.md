# RoboKit Documentation

## Overview
**RoboKit** is a ...

## Requirements
- visionOS 2.0+

## Installation
```swift
// Using Swift Package Manager (SPM)
.package(url: "https://github.com/Spatial-Dragons/RoboKit.git", from: "1.0.0")
```

## Setup Guide
### 1. Configure Permissions
Add the following entry in `Info.plist` to request world-sensing permission:

```xml
<key>NSWorldSensingUsageDescription</key>
<string>This app requires world sensing capabilities to track reference images.</string>
```

### 2. Create AR Reference Image Group
- Open Xcode
- Add an **AR Resource Group** in `xcassets`
- Name the group (e.g., `"reference-images"`)
- Add reference images for tracking and set their **physical size**

### 3. Define Reference Images in Code
Each reference image must include:
- `textureName`: The name of the image in `xcassets`
- `rootOffset`: The offset (in meters) from the intended physical root point.

Example:

```swift
import RoboKit

let referenceImages: [ReferenceImage] = [
    ReferenceImage(textureName: "DataMatrix0", rootOffset: .init(x: -0.1135, y: 0, z: 0.175)),
    ReferenceImage(textureName: "DataMatrix1", rootOffset: .init(x: 0.1135, y: 0, z: -0.175))
]
```

### 4. Compute Root Position
Once reference images are defined, pass them to the framework:

```swift
var rootTransform = RoboKit.computeRootTransform(for: "data-matrices", images: referenceImages)
print(rootTransform)
```

## Behavior
- If multiple images are provided, the framework **computes the center** based on `rootOffset` values.
- If only **one** image is used, set `rootOffset = .zero` so its center becomes the reference point.

## API Reference
### `ReferenceImage`
```swift
struct ReferenceImage {
    let textureName: String
    let rootOffset: SIMD3<Float>
}
```

### `RoboKit.computeRootPosition`
```swift
static func computeRootPosition(for groupName: String, images: [ReferenceImage]) -> SIMD3<Float>
```
- **groupName**: Name of the AR Resource Group in `xcassets`
- **images**: Array of `ReferenceImage`
- **Returns**: Computed root position (`SIMD3<Float>`)