//
//  ServiceLocatorRegisterAndRetrieveTests.swift
//  
//
//  Created by Max on 02/03/2024.
//

@testable import ServiceInjector
import XCTest

final class ServiceLocatorRegisterAndRetrieveTests: XCTestCase {

    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }
    
    func testServiceRegistrationAndRetrieval() {
        do {
            try ServiceLocator.register(as: TestServiceProtocol.self, using: TestService())
            
            let service: TestServiceProtocol = try ServiceLocator.locateService(ofType: TestServiceProtocol.self)
            
            XCTAssertTrue(service is TestService, "El servicio localizado debe ser de tipo TestService.")
        } catch ServiceLocatorError.serviceAlreadyRegistered(let serviceName) {
            XCTFail("Error: El servicio \(serviceName) ya está registrado.")
        } catch {
            XCTFail("Error inesperado: \(error).")
        }
    }
}
