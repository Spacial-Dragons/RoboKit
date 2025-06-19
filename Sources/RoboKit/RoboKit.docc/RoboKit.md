# ``RoboKit``

RoboKit is a framework designed to facilitate the integration between visionOS applications and robotics software.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "RoboKitLogo.png", 
        alt: "RoboKit logo.")
    @PageColor(blue)
}

## Overview

RoboKit provides essential tools and modules for connecting **visionOS** applications with robotic systems. The framework includes components for real-time tracking, communication over network sockets, and intuitive user interfaces for controlling robotic actions.

You can detect and track images using the ``ImageTracker`` module, which allows vision-based anchoring and calibration. With ``TrackingImage``, you define reference markers used to establish shared understanding between the physical and virtual world.

RoboKit also supports robust socket communication via the ``TCPClient`` and ``TCPServer`` classes. Data is encoded and decoded using ``CodingManager`` and structured with ``CPRMessageModel`` to ensure clear and consistent message passing.

For interaction, the ``InputEntityManager`` provides an intuitive interface to manipulate robot parameters using 3D sliders and controls. You can position and rotate a control entity using ``InputEntityPositionView`` and ``InputEntityRotationSlider``.

The **UI Module** provides a comprehensive collection of SwiftUI components for creating intuitive robotic control interfaces. It includes form controls, input entity views, control panel elements, and accessory components that work seamlessly with other RoboKit modules.

RoboKit makes it easier to build immersive, real-time robotic control interfaces in visionOS.

 [View Demo Project](https://github.com/Spacial-Dragons/RoboKit-Demo) — A showcase app demonstrating the different modules available in RoboKit.


### Featured

@Links(visualStyle: detailedGrid) {
    - <doc:ImageTrackerModule>
    - <doc:SocketModule>
    - <doc:InputEntity>
    - <doc:UIModule>
}

## Topics

### Essentials

- ``ImageTracker``
- ``TCPClient``
- ``InputEntityManager``
- ``FormManager``

### Image Tracker

- ``ImageTracker``
- ``TrackingImage``

### Socket

- ``TCPClient``
- ``TCPServer``
- ``CPRMessageModel``
- ``CodingManager``

### Input Entity

- ``InputEntityManager``
- ``InputEntityPositionView``
- ``InputEntityRotationSlider``
- ``InputEntityAxis``

### UI Module

- ``FormManager``
- ``FormPositionTextField``
- ``FormRotationTextField``
- ``InputEntityPositionText``
- ``InputEntityRotationSlider``
- ``InputEntityRotationText``
- ``DataModePicker``
- ``SendDataButton``
- ``ClawControlToggle``
- ``ObjectWidthTextField``
- ``ObjectWidthUnitPicker``
- ``SegmentedControlPicker``
