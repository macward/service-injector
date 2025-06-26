//
//  ServiceLocatorServiceOverrideTests.swift
//  
//
//  Created by Max on 02/03/2024.
//

@testable import ServiceInjector
import XCTest

final class ServiceLocatorServiceOverrideTests: XCTestCase {

    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        ServiceLocator.unregister(type: TestServiceProtocol.self)
    }
    
    // Test that a registered service can be successfully overridden
    func testServiceOverride() {
        // Register the initial service implementation
        XCTAssertNoThrow(try ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .runtime, using: TestService()), "Initial registration should succeed.")
        
        // Define a new service implementation to override the existing one
        class TestServiceOverride: TestServiceProtocol {}
        
        // Attempt to override the previously registered service
        ServiceLocator.override(as: TestServiceProtocol.self, withLifecycle: .runtime, using: TestServiceOverride())
        
        // Locate the service after overriding
        let locatedService: TestServiceProtocol = try! ServiceLocator.locateService(ofType: TestServiceProtocol.self, withLifecycle: .runtime)
        
        // Verify that the located service is an instance of the override class
        XCTAssertTrue(locatedService is TestServiceOverride, "The located service should be an instance of the override class.")
    }

}
