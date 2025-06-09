//
//  ServerTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 28/05/25.
//
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("Connection Tests")
struct ConnectionTests {
    let mockConnection: Connection
    let testMessage: CPRMessageModel
    let testData: Data

    init() async {
        let nwConnection = NWConnection(host: .ipv4(.loopback), port: 1234, using: .tcp)
        mockConnection = await Connection(nwConnection: nwConnection)
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
        testData = Data("Test data".utf8)
    }

    @Test("Test setupConnection closure is called")
    func testSetupConnectionCallback() async {
        var flag = false
        await mockConnection.setSetupConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .setup)
        #expect(flag == true)
    }

    @Test("Test waitingConnection closure is called")
    func testWaitingConnectionCallback() async {
        var flag = false
        await mockConnection.setWaitingConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .waiting(NWError.posix(.ECONNREFUSED)))
        #expect(flag == true)
    }

    @Test("Test preparingConnection closure is called")
    func testPreparingConnectionCallback() async {
        var flag = false
        await mockConnection.setPreparingConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .preparing)
        #expect(flag == true)
    }

    @Test("Test readyConnection closure is called")
    func testReadyConnectionCallback() async {
        var flag = false
        await mockConnection.setReadyConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .ready)
        #expect(flag == true)
    }

    @Test("Test cancelledConnection closure is called")
    func testCancelledConnectionCallback() async {
        var flag = false
        await mockConnection.setCancelledConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .cancelled)
        #expect(flag == true)
    }

    @Test("Test failedConnection closure is called")
    func testFailedConnectionCallback() async {
        var flag = false
        await mockConnection.setFailedConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .failed(NWError.posix(.ETIMEDOUT)))
        #expect(flag == true)
    }

    // MARK: - Security Configuration Tests

    @Test("Test SecurityOptions token provider functionality")
    func testSecurityOptionsTokenProvider() async {
        // Test that token provider is called by checking the token is included in secure message
        let expectedToken = "test-token-for-verification"
        let security = SecurityOptions(
            useTLS: true,
            tokenProvider: { expectedToken }
        )
        // Create a secure message using the same logic as sendMessage
        let secureMessage = await mockConnection.createSecureMessage(payload: testMessage, security: security)
        // Verify the token was added
        #expect(secureMessage.token == expectedToken)
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
        #expect(secureMessage.payload.positionAndRotation == testMessage.positionAndRotation)
    }

    @Test("Test SecurityOptions checksum provider functionality")
    func testSecurityOptionsChecksumProvider() async {
        // Test that checksum provider is called by checking the checksum is included
        let security = SecurityOptions(
            useTLS: true,
            checksumProvider: { data in
                "checksum-\(data.count)-bytes"
            }
        )
        // Create a secure message using the same logic as sendMessage
        let secureMessage = await mockConnection.createSecureMessage(payload: testMessage, security: security)
        // Verify the checksum was added and follows expected format
        #expect(secureMessage.checksum != nil)
        #expect(secureMessage.checksum?.contains("checksum-") == true)
        #expect(secureMessage.checksum?.contains("-bytes") == true)
        #expect(secureMessage.payload.clawControl == testMessage.clawControl)
    }
}
