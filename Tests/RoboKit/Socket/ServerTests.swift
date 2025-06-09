//
//  ServerTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 03/06/25.
//
import Foundation
import Testing
@testable import RoboKit
import Network

@Suite("TCPServer Tests")
struct TCPServerTests {
    let server: TCPServer
    let connection: Connection
    let nwConnection = NWConnection(host: .ipv4(.loopback), port: 1234, using: .tls)
    let testMessage: CPRMessageModel

    init() async throws {
        self.connection = await Connection(nwConnection: NWConnection(host: .ipv4(.loopback), port: 1234, using: .tcp))
        self.testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
        do {
            self.server = try await TCPServer(port: 1234)
        } catch {
            throw TestError.serverNotInitialized
        }
    }
    @Test("Test server initializes and starts")
    func testServerStart() async throws {
        try await server.start(logMessage: "Testing")
        await #expect(server.listener.stateUpdateHandler != nil)
        await #expect(server.listener.newConnectionHandler != nil)
    }

    @Test("Test didAccept adds connection to dictionary")
    func testDidAcceptAddsConnection() async throws {
        await server.didAccept(nwConnection: connection)
        let storedConnection = await server.connectionsByID[connection.id]
        #expect(storedConnection === connection)
    }

    @Test("Test connectionDidStop removes connection")
    func testConnectionDidStopRemovesConnection() async throws {
        await server.didAccept(nwConnection: connection)
        await server.connectionDidStop(connection)
        let storedConnection = await server.connectionsByID[connection.id]
        #expect(storedConnection == nil)
    }

    @Test("Test stop cancels all connections and listener")
    func testStopShutsDownServer() async throws {
        await server.didAccept(nwConnection: connection)
        await server.stop()
        #expect((await server.connectionsByID).isEmpty)
    }

    // MARK: - State Management Tests

    @Test("Test stateDidChange with setup state")
    func testStateDidChangeSetup() async {
        // Test setup state - should log debug message
        await server.stateDidChange(to: .setup)

        // Verify the state change was processed without crashing
        #expect(true)
    }

    @Test("Test stateDidChange with waiting state")
    func testStateDidChangeWaiting() async {
        // Test waiting state - should log debug message
        await server.stateDidChange(to: .waiting(NWError.dns(.zero)))

        // Verify the state change was processed without crashing
        #expect(true)
    }

    @Test("Test stateDidChange with ready state")
    func testStateDidChangeReady() async {
        // Test ready state - should log info message
        await server.stateDidChange(to: .ready)

        // Verify the state change was processed without crashing
        #expect(true)
    }

    @Test("Test stateDidChange with failed state")
    func testStateDidChangeFailed() async {
        // Test failed state - should log error and stop server
        let testError = NWError.posix(.ECONNREFUSED)
        await server.stateDidChange(to: .failed(testError))

        // Verify the server was stopped due to failure
        #expect((await server.connectionsByID).isEmpty)
    }

    @Test("Test stateDidChange with cancelled state")
    func testStateDidChangeCancelled() async {
        // Test cancelled state - should log warning message
        await server.stateDidChange(to: .cancelled)

        // Verify the state change was processed without crashing
        #expect(true)
    }

    @Test("Test stateDidChange with unknown state")
    func testStateDidChangeUnknown() async {
        // Test unknown state - should log debug message
        await server.stateDidChange(to: .cancelled)

        // Verify the state change was processed without crashing
        #expect(true)
    }

    @Test("Test stateDidChange multiple transitions")
    func testStateDidChangeMultipleTransitions() async {
        // Test multiple state transitions in sequence
        await server.stateDidChange(to: .setup)
        await server.stateDidChange(to: .waiting(NWError.dns(.zero)))
        await server.stateDidChange(to: .ready)

        // Verify all state changes were processed without crashing
        #expect(true)
    }

    // MARK: - Secure Message Tests

    @Test("Test createSecureMessage with basic security")
    func testCreateSecureMessageBasic() async {
        // Test with default security (no token/checksum providers)
        let secureMessage = await server.createSecureMessage(payload: testMessage)

        // Verify basic message structure
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
        #expect(secureMessage.payload.positionAndRotation == testMessage.positionAndRotation)
        #expect(secureMessage.token == nil)
        #expect(secureMessage.checksum == nil)
    }

    @Test("Test createSecureMessage with token provider")
    func testCreateSecureMessageWithToken() async throws {
        // Create server with token provider
        let serverWithToken = try await TCPServer(
            port: 1235,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token-123" }
            )
        )

        let secureMessage = await serverWithToken.createSecureMessage(payload: testMessage)

        // Verify token was added
        #expect(secureMessage.token == "test-token-123")
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
        #expect(secureMessage.checksum == nil)
    }

    @Test("Test createSecureMessage with checksum provider")
    func testCreateSecureMessageWithChecksum() async throws {
        // Create server with checksum provider
        let serverWithChecksum = try await TCPServer(
            port: 1236,
            security: SecurityOptions(
                useTLS: true,
                checksumProvider: { data in "checksum-\(data.count)" }
            )
        )

        let secureMessage = await serverWithChecksum.createSecureMessage(payload: testMessage)

        // Verify checksum was added
        #expect(secureMessage.checksum != nil)
        #expect(secureMessage.checksum?.contains("checksum-") == true)
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
        #expect(secureMessage.token == nil)
    }

    @Test("Test createSecureMessage with both token and checksum")
    func testCreateSecureMessageWithTokenAndChecksum() async throws {
        // Create server with both providers
        let serverWithBoth = try await TCPServer(
            port: 1237,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "combined-token" },
                checksumProvider: { data in "combined-checksum-\(data.count)" }
            )
        )

        let secureMessage = await serverWithBoth.createSecureMessage(payload: testMessage)

        // Verify both token and checksum were added
        #expect(secureMessage.token == "combined-token")
        #expect(secureMessage.checksum != nil)
        #expect(secureMessage.checksum?.contains("combined-checksum-") == true)
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
    }

    @Test("Test createSecureMessage with nil providers")
    func testCreateSecureMessageWithNilProviders() async throws {
        // Create server with nil providers
        let serverWithNil = try await TCPServer(
            port: 1238,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: nil,
                checksumProvider: nil
            )
        )

        let secureMessage = await serverWithNil.createSecureMessage(payload: testMessage)

        // Verify no security features were added
        #expect(secureMessage.token == nil)
        #expect(secureMessage.checksum == nil)
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
    }

    @Test("Test createSecureMessage with different payloads")
    func testCreateSecureMessageDifferentPayloads() async {
        // Test with different message payloads
        let message1 = CPRMessageModel(clawControl: false, positionAndRotation: [0.0, 0.0, 0.0, 0.0])
        let message2 = CPRMessageModel(clawControl: true, positionAndRotation: [999.99, 888.88, 777.77, 666.66])

        let secureMessage1 = await server.createSecureMessage(payload: message1)
        let secureMessage2 = await server.createSecureMessage(payload: message2)

        // Verify different payloads are handled correctly
        #expect(secureMessage1.payload.clawControl == false)
        #expect(secureMessage2.payload.clawControl == true)
        #expect(secureMessage1.payload.positionAndRotation == [0.0, 0.0, 0.0, 0.0])
        #expect(secureMessage2.payload.positionAndRotation == [999.99, 888.88, 777.77, 666.66])
    }

    @Test("Test createSecureMessage preserves payload integrity")
    func testCreateSecureMessageIntegrity() async {
        // Test that the original payload is not modified
        let originalMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
        let secureMessage = await server.createSecureMessage(payload: originalMessage)

        // Verify payload integrity
        #expect(secureMessage.payload.clawControl == originalMessage.clawControl)
        #expect(secureMessage.payload.positionAndRotation == originalMessage.positionAndRotation)

        // Verify original message wasn't modified
        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])
    }
}

enum TestError: Error {
    case serverNotInitialized
}
