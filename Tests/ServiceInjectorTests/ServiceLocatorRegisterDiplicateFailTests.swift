//
//  ServiceLocatorRegisterDiplicateFailTests.swift
//  
//
//  Created by Max on 02/03/2024.
//

@testable import ServiceInjector
import XCTest

final class ServiceLocatorRegisterDiplicateFailTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }
    
    // Test failure to register a service that already exists without using the override method
    func testRegisterDuplicateServiceWithoutOverrideShouldFail() {
        // Attempt to register the service for the first time
        XCTAssertNoThrow(try ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .runtime, using: TestService()), "First registration should succeed.")
        
        // Attempt to register the same service again and expect an error
        XCTAssertThrowsError(try ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .runtime, using: TestService())) { error in
            // Verify the error is the expected type and value
            guard let serviceLocatorError = error as? ServiceLocatorError else {
                return XCTFail("Expected ServiceLocatorError")
            }
            
            switch serviceLocatorError {
            case .serviceAlreadyRegistered(let serviceName):
                XCTAssertEqual(serviceName, "\(TestServiceProtocol.self)", "The service name in the error should match the duplicated service.")
            default:
                XCTFail("Expected serviceAlreadyRegistered error")
            }
        }
    }
}
