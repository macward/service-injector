//
//  InjectPropertyWrapperTests.swift
//  
//
//  Created by Max on 02/03/2024.
//

@testable import ServiceInjector
import XCTest

final class InjectPropertyWrapperTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }
    
    func testInjectPropertyWrapper() {
        // Registro de un servicio de prueba en el ServiceLocator
        let testService = TestService()
        try? ServiceLocator.register(as: TestServiceProtocol.self, using: testService)
        
        // Uso de @Inject para inyectar el servicio en una propiedad
        class TestConsumer {
            @Inject var service: TestServiceProtocol
        }
        
        let consumer = TestConsumer()
        
        // Verificación de que el servicio inyectado es el mismo que el registrado
        XCTAssertTrue(consumer.service === testService, "El servicio inyectado debe ser el mismo que el registrado.")
    }
}

