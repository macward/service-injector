import XCTest
@testable import ServiceInjector

final class AsyncInjectPropertyWrapperTests: XCTestCase {
    override func tearDownWithError() throws {
        ServiceLocator.clearCache()
    }

    func testAsyncInjectPropertyWrapper() async throws {
        let service = TestService()
        try ServiceLocator.register(as: TestServiceProtocol.self, withLifecycle: .runtime, using: service)

        class Consumer {
            @AsyncInject var injected: Task<TestServiceProtocol, Error>
        }

        let consumer = Consumer()
        let retrieved = try await consumer.injected.value
        XCTAssertTrue(retrieved as AnyObject === service)
    }
}
