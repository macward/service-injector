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
struct Inject<T> {
    /// The instance of the service that is being injected.
    private var service: T
    
    /// An optional identifier to locate a specific service instance if multiple
    /// instances of the same type are registered in `ServiceLocator`.
    private var identifier: String?

    /// Initializes a new injectable service instance.
    ///
    /// The initializer looks up and retrieves the service from `ServiceLocator`.
    /// If an identifier is provided, it attempts to locate the service using that identifier.
    ///
    /// - Parameter identifier: An optional unique identifier for the service.
    init(identifier: String? = nil) {
        self.identifier = identifier
        // Locate and cache the service using ServiceLocator.
        do {
            self.service = try ServiceLocator.locateService(ofType: T.self, withIdentifier: identifier)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// A computed property that gets or sets the wrapped value.
    ///
    /// This property provides access to the injected service instance. It allows
    /// the consumer of the property wrapper to interact with the service directly.
    var wrappedValue: T {
        get { service }
        mutating set { service = newValue }
    }
}
