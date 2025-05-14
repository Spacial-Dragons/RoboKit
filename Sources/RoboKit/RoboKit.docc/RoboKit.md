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

For interaction, the ``InputSphereManager`` provides an intuitive interface to manipulate robot parameters using 3D sliders and controls. You can position and rotate a control sphere using ``InputSpherePositionView`` and ``InputSphereRotationSlider``.

RoboKit makes it easier to build immersive, real-time robotic control interfaces in visionOS.


### Featured

@Links(visualStyle: detailedGrid) {
    - <doc:ImageTrackerModule>
    - <doc:SocketModule>
}

## Topics

### Essentials

- ``ImageTracker``
- ``TCPClient``
- ``InputSphereManager``

### Image Tracker

- ``ImageTracker``
- ``TrackingImage``

### Socket

- ``TCPClient``
- ``TCPServer``
- ``CPRMessageModel``
- ``CodingManager``

### Input Sphere

- ``InputSphereManager``
- ``InputSpherePositionView``
- ``InputSphereRotationSlider``
- ``InputSphereAxis``
