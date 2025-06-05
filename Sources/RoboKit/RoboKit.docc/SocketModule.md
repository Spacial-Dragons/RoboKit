# Socket

@Metadata {
    @PageImage(purpose: card, source: "SocketModuleCard", alt: "Socket Module Card")
}

The Socket module provides a pre-structured TCP socket that allows for communication between the visionOS application and external software responsible for controlling a robot.

## Overview

This module levereages the Network Framework to provide a convenient structure for a TCP socket that can be initialized with a specified host and port to establish communication with a server.

## Setup

### Initialize a TCPServer Instance

### Initialize a TCPClient Instance

To create a ``TCPClient`` and define its destination host and port:

```swift
var client: TCPClient = TCPClient(host: "localhost", port: 12345)
````

> Note: The host and port should match the address and port of the server you wish to connect to.

-------

# Socket

@Metadata {
    @PageImage(purpose: card, source: "SocketModuleCard", alt: "Socket Module Card")
}

The TCP Communication module provides asynchronous client-server communication over TCP sockets using Apple's Network framework and Swift Concurrency. This module includes three core actors: `TCPClient`, `TCPServer`, and `Connection`.

## Overview

This module enables structured and concurrent-safe communication between a TCP client and server. The server listens on a given port for incoming client connections, while the client initiates a connection and can send encoded messages. The enconding and decoding process can be facilitated by the ``CodingManager``. 

## TCPClient

An actor responsible for managing the lifecycle of a TCP client.

### Initialization
To initialize your TCP client, simply initialize the actor with the host and port you wish to connect to and assing it to a variable.
```swift
let client = TCPClient(host: "localhost", port: 12345)
```

### Start Connection
Once ``TCPClient`` has been instantiated, the `startConnection` method can be called in order to stablish a connection to the server.
```swift
await client.startConnection(value: encodedData)
```

* `value`: The `Data` to send after connecting.

### Responsibilities

* Connects to a TCP server.
* Sends encoded data following the establishment of the connection.
* Sets up state and receive handlers.

## TCPServer

An actor responsible for creating and managing a TCP server listener, handling multiple concurrent client connections.

> Note: The usage of the TCPServer is not a necessary addition to ``TCPClient``.

### Initialization
Initialize the server designating a port it can listen on.

```swift
let server = try await TCPServer(port: 12345)
```

### Start Listening
Call the start method to allow the server to start listening for possible connections.
```swift
try await server.start(logMessage: "Server started")
```

### Responsibilities

* Creates and starts an `NWListener`.
* Accepts and manages multiple client connections.
* Instantiates a `Connection` actor for each client.

## Connection

An actor that encapsulates a TCP connection between the server and a single client. Utilize the Connections properties to add custom behavior.

### Properties

* `setupConnection`: Called when connection enters the setup state.
* `waitingConnection`: Called when the connection is waiting for network resources.
* `preparingConnection`: Called when preparing to be ready.
* `readyConnection`: Called when connection is established and ready.
* `failedConnection`: Called if the connection fails.
* `cancelledConnection`: Called when the connection is cancelled.

### Lifecycle

* State updates are monitored via `NWConnection.State`.
* `setupReceive` begins the data reception loop.
* `send(data:)` transmits messages.

## Notes

> Important: All actor methods interacting with the network must be called using `async/await` to ensure concurrency safety.

> Warning: This module uses `NWConnection` and `NWListener`, which are not supported in Swift Playgrounds or the iOS simulator.

> Tip: To test the actors in a SwiftUI app, inject them via `@State` or `@Environment` and interact through `Task {}` blocks.

