# UI Module

@Metadata {
    @PageImage(purpose: card, source: "UIModuleCard", alt: "UI Module Card")
}

The UI Module provides a comprehensive collection of SwiftUI components designed to create intuitive and accessible user interfaces for robotic control applications in visionOS. This module includes form controls, input sphere views, control panel elements, and accessory components that work seamlessly with other RoboKit modules.

## Overview

The UI Module offers pre-built SwiftUI views that simplify the creation of robotic control interfaces. These components are designed to work with the ``InputSphereManager``, ``FormManager``, and socket communication modules to provide a complete user experience for robot control applications.

## Form Views

A collection of text field components for entering position and rotation values in forms.

### FormPositionTextField

![FormPositionTextField](FormPositionTextField)

A text field for entering position values along a specific axis in the ROS coordinate system.

```swift
FormPositionTextField(axis: .lateral)  // X-axis
FormPositionTextField(axis: .longitudinal)  // Y-axis  
FormPositionTextField(axis: .vertical)  // Z-axis
```

> Note: `FormPositionTextField` and `FormRotationTextField` bind directly to ROS coordinate system data for immediate updates.


### FormRotationTextField

![FormRotationTextField](FormRotationTextField)

A text field for entering rotation values using Euler angles.

```swift
FormRotationTextField(eulerAngle: .roll)   // Rotation X
FormRotationTextField(eulerAngle: .pitch)  // Rotation Y
FormRotationTextField(eulerAngle: .yaw)    // Rotation Z
```

### FormPositionText

![FormPositionText](FormPositionText)

A read-only text view that displays position values along a specific axis.

```swift
FormPositionText(axis: .lateral)
FormPositionText(axis: .longitudinal)
FormPositionText(axis: .vertical)
```

## Input Sphere Views

Components for displaying and controlling the Input Sphere's position and orientation.

### InputSpherePositionText

![InputSpherePositionText](InputSpherePositionText)

Displays the current position of the Input Sphere along a specific axis.

```swift
InputSpherePositionText(axis: .lateral, showFullDescription: true)
InputSpherePositionText(axis: .longitudinal)
InputSpherePositionText(axis: .vertical)
```

> Important: The `InputSpherePositionText` component automatically converts position data to ROS coordinates for display.

### InputSphereRotationSlider

![InputSphereRotationSlider](InputSphereRotationSlider)

Interactive sliders for adjusting the Input Sphere's orientation using Euler angles.

```swift
InputSphereRotationSlider(
    rootPoint: rootEntity,
    eulerAngle: .roll,
    maxValue: 180,
    minValue: -180,
    step: 1,
    showMinMax: true
)
```

### InputSphereRotationText

![InputSphereRotationText](InputSphereRotationText)

Displays the current rotation values of the Input Sphere in degrees.

```swift
InputSphereRotationText(eulerAngle: .roll)
InputSphereRotationText(eulerAngle: .pitch)
InputSphereRotationText(eulerAngle: .yaw)
```

## Control Panel Views

Components for managing data transmission and control modes.

### DataModePicker

![DataModePicker](DataModePicker)

A segmented control for selecting between live and set data transmission modes.

```swift
@State private var selectedDataMode: DataMode = .live

DataModePicker(selectedDataMode: $selectedDataMode)
```

### SendDataButton

![SendDataButton](SendDataButton)

An animated button for sending data with visual feedback and accessibility support.

```swift
@State private var isSendingData: Bool = false

SendDataButton(
    onSendLiveData: { /* Live data handler */ },
    onSendSetData: { /* Set data handler */ },
    isSendingData: $isSendingData,
    selectedDataMode: $selectedDataMode
)
```

> Warning: The `SendDataButton` automatically stops sending data when switching from live mode to set mode.

## Accessory Views

Utility components for common UI patterns and controls.

### ClawControlToggle

![ClawControlToggle](ClawControlToggle)

A segmented control for toggling between open and closed claw states.

```swift
@State private var clawShouldOpen: Bool = false

ClawControlToggle(clawShouldOpen: $clawShouldOpen)
```

### ObjectWidthTextField

![ObjectWidthTextField](ObjectWidthTextField)

A text field for entering object width values with number formatting.

```swift
@State private var objectWidth: Float = 0.7

ObjectWidthTextField(objectWidth: $objectWidth)
```

### ObjectWidthUnitPicker

![ObjectWidthUnitPicker](ObjectWidthUnitPicker)

A segmented control for selecting measurement units (millimeters, centimeters, meters).

```swift
@State private var objectWidthUnit: ObjectWidthUnit = .centimeters

ObjectWidthUnitPicker(objectWidthUnit: $objectWidthUnit)
```

> Tip: Use `ObjectWidthUnitPicker` with `ObjectWidthTextField` for complete object width input with unit selection.

## Picker Components

### SegmentedControlPicker

![SegmentedControlPicker](SegmentedControlPicker)

A customizable segmented control component with accessibility support.

```swift
let options = [
    SegmentedControlItem(label: "Option 1"),
    SegmentedControlItem(label: "Option 2", accessibilityLabel: Text("Second option"))
]

@State private var selectedIndex: Int = 0

SegmentedControlPicker(
    items: options,
    selectedIndex: $selectedIndex,
    accessibilityLabel: Text("Selection Control")
)
```

## Integration with Other Modules

The UI Module components are designed to work seamlessly with other RoboKit modules:

- **Form Views** integrate with ``FormManager`` for position and rotation data
- **Input Sphere Views** work with ``InputSphereManager`` for 3D control
- **Control Panel Views** support ``DataMode`` and socket communication
- **Accessory Views** provide common controls for robot parameters

## Accessibility

All UI components include comprehensive accessibility support:

- Proper accessibility labels and values
- VoiceOver compatibility
- Reduced motion support for animations
- Semantic grouping of related controls
