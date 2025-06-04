<p align="center">
  <img src="Media/RoboKitLogo-light.png#gh-light-mode-only" width="110">
  <img src="Media/RoboKitLogo-dark.png#gh-dark-mode-only" width="110">
</p>

<h2 align="center">RoboKit</h2>

## Overview
<<<<<<< HEAD
**RoboKit** is a framework designed to faciliate the integration between visionOS applications and robotics software.

## Requirements
- visionOS 2.0+
- XCode
=======
**RoboKit** is a framework designed to facilitate the integration between visionOS applications and robotics software.

## Requirements
- visionOS 2.0+
- Xcode
>>>>>>> main

## Installation
To install RoboKit using [Swift Package Manager](https://github.com/apple/swift-package-manager), follow the [official tutorial by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) and use the URL for this repository:

1. In Xcode, select **File → Add Packages...**
2. Enter the following URL:
   ```
   https://github.com/Spacial-Dragons/RoboKit
   ```
3. Select the Dependency Rule as `Up to Next Major Version`
<<<<<<< HEAD
---

## Socket Module

### Description
The Socket module provides a pre-structured TCP socket that allows for communication between the visionOS application and the software that responsible for the robot.

### Setup Guide

#### 1. Initialize a client instance
- Intilize and assign a `TCPClient` instance to a variable, definiting its host and port:
```swift
var client: TCPClient = TCPClient(host: "localhost", port: 12345)
```
> [!NOTE]  
> The host and port assigned to the client should be those of the server that you desire to reach.  
=======

## Documentation

Comprehensive documentation for **RoboKit** is available online. It includes getting started guides, API references, and integration tips for visionOS and robotics platforms.
>>>>>>> main

**Access the full documentation here:** [https://robokit.vercel.app/docs](https://robokit.vercel.app/docs)

For advanced usage examples, please refer to the [Demo project](https://github.com/Spacial-Dragons/RoboKit-Demo) demonstrating the capabilities of the `RoboKit`.

## Contributing to RoboKit

Contributions to RoboKit are welcomed and encouraged! Please see the
[Contributing to RoboKit guide](CONTRIBUTING.md).

Before submitting the pull request, please make sure you have *tested your changes* and that they follow the RoboKit project [guidelines for contributing code](CONTRIBUTING.md#Commit-Guidelines).
