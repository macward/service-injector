//
//  ServiceInjector.swift
//
//
//  Created by Max on 06/02/2024.
//

/// A property wrapper for dependency injection.
///
/// This property wrapper uses `ServiceLocator` to inject dependencies into properties.
/// It simplifies the usage of the service locator pattern by automatically fetching
/// and caching the required service instance.
///
/// - Example Usage:
///
/// ```
/// class SomeServiceConsumer {
///     @Inject var myService: MyServiceProtocol
///     @Inject(identifier: "SpecificService") var specificService: MyServiceProtocol
///
///     func useService() {
///         myService.doSomething()
///         specificService.doSomethingElse()
///     }
/// }
/// ```
///
/// In the example above, `myService` and `specificService` are automatically injected
/// with the instances registered in `ServiceLocator` by their type and optional identifier.
@propertyWrapper
public struct Inject<T> {
    /// The instance of the service that is being injected.
    private var service: T
    
    /// Initializes a new injectable service instance with an optional lifecycle and identifier.
    ///
    /// The initializer looks up and retrieves the service from `ServiceLocator`.
    /// If an identifier is provided, it attempts to locate the service using that identifier.
    ///
    /// - Parameters:
    ///   - lifecycle: The lifecycle of the service (e.g., `.singleton` or `.runtime`).
    ///   - identifier: An optional unique identifier for the service.

    public init(_ lifecycle: ServiceLifecycle = .runtime, identifier: String? = nil) {
        do {
            self.service = try ServiceLocator.locateService(ofType: T.self, withLifecycle: lifecycle, withIdentifier: identifier)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// A computed property that gets or sets the wrapped value.
    ///
    /// This property provides access to the injected service instance. It allows
    /// the consumer of the property wrapper to interact with the service directly.
    public var wrappedValue: T {
        get { service }
        mutating set { service = newValue }
    }
}
