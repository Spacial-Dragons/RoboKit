# Socket

The Socket module provides a pre-structured TCP socket that allows for communication between the visionOS application and external software responsible for controlling a robot.

## Overview

This module offers a convenient ``TCPClient`` that can be initialized with a specified host and port to establish communication with a remote server.

## Setup

### Initialize a Client Instance

To create a ``TCPClient`` and define its destination host and port:

```swift
var client: TCPClient = TCPClient(host: "localhost", port: 12345)
````

> Note: The host and port should match the address and port of the server you wish to connect to.
