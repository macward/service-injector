import XCTest
@testable import ServiceInjector

final class ServiceLocatorAsyncTests: XCTestCase {
    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }

    func testLocateServiceAsync() async throws {
        try ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .runtime, using: TestService())
        let service: TestServiceProtocol = try await ServiceLocator.locateServiceAsync(ofType: TestServiceProtocol.self, withLifecycle: .runtime)
        XCTAssertTrue(service is TestService)
    }
}
