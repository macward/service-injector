import XCTest
@testable import ServiceInjector

final class ServiceLocatorThreadSafetyTests: XCTestCase {

    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }

    func testConcurrentSingletonAccessReturnsSameInstance() {
        let service = TestService()
        try? ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .singleton, using: service)

        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10

        let queue = DispatchQueue.global(qos: .userInitiated)
        for _ in 0..<10 {
            queue.async {
                let retrieved: TestServiceProtocol = try! ServiceLocator.locateService(ofType: TestServiceProtocol.self, withLifecycle: .singleton)
                XCTAssertTrue(retrieved as AnyObject === service)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
