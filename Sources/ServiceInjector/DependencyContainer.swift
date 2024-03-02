//
//  ServiceLocator.swift
//
//
//  Created by Max on 06/02/2024.
//

import Foundation

enum ServiceLocatorError: Error {
    case serviceAlreadyRegistered(String)
    case serviceNotFound(String)
}

/// A service locator pattern implementation for dependency injection and service management.
final public class ServiceLocator {
    
    /// A cache to store initialized services.
    private var cache: [String: Any] = [:]
    
    /// A dictionary of closures that initialize services when needed.
    private var serviceFactories: [String: () -> Any] = [:]
    
    /// The singleton instance of the service locator.
    private static let shared = ServiceLocator()
    
    /// Registers a service with an optional identifier, using a factory closure.
    ///
    /// This method allows you to register a service of a specific type with the service locator.
    /// The service is not instantiated immediately; instead, a factory closure is provided
    /// which will be used to instantiate the service when it is first requested.
    ///
    /// If a service of the same type (and identifier, if provided) has already been registered,
    /// this method throws an error to prevent accidental overwrites and ensure service uniqueness.
    ///
    /// - Parameters:
    ///   - type: The type of the service to register. This should be a protocol or superclass
    ///           that the service conforms to or inherits from.
    ///   - identifier: An optional unique identifier for the service. This is useful if you need
    ///                 to register multiple instances of the same service type, and want to
    ///                 retrieve them based on an identifier.
    ///   - factory: A closure that returns an instance of the service. This closure is only
    ///              executed when the service is first requested, allowing for lazy initialization.
    ///
    /// - Throws: `ServiceLocatorError.serviceAlreadyRegistered` if a service with the same type
    ///           (and identifier, if provided) has already been registered.
    ///
    /// - Example:
    ///
    /// ```
    /// do {
    ///     try ServiceLocator.register(as: MyServiceProtocol.self) {
    ///         MyService()
    ///     }
    /// } catch ServiceLocatorError.serviceAlreadyRegistered(let serviceName) {
    ///     print("A service with the name \(serviceName) has already been registered.")
    /// } catch {
    ///     print("Unexpected error: \(error).")
    /// }
    /// ```
    ///
    /// This method ensures that each service is registered only once (unless explicitly overwritten)
    /// to maintain the integrity and predictability of your service dependencies.
    public static func register<T>(as type: T.Type, identifier: String? = nil, using factory: @autoclosure @escaping () -> T) throws {
        let key = identifier ?? String(describing: type.self)
        guard shared.serviceFactories[key] == nil else {
            throw ServiceLocatorError.serviceAlreadyRegistered(key)
        }
        shared.serviceFactories[key] = factory
    }
    
    /// Overrides a previously registered service with a new factory closure.
    ///
    /// Use this method to replace an existing service registration with a new implementation.
    /// This can be useful in scenarios where you need to change the behavior of a service
    /// dynamically at runtime, or for replacing real services with mock versions in testing environments.
    ///
    /// The method replaces the existing factory closure for the specified service type and identifier
    /// with a new one provided. If the service was previously instantiated and cached, the cache is cleared,
    /// ensuring that the next request for the service will use the new factory closure to create an instance.
    ///
    /// - Parameters:
    ///   - type: The type of the service to override. This should be a protocol or superclass
    ///           that the service conforms to or inherits from.
    ///   - identifier: An optional unique identifier for the service. Use this if you have multiple
    ///                 instances of the same service type registered and need to distinguish between them
    ///                 for replacement.
    ///   - factory: A closure that returns an instance of the new service. This closure is executed
    ///              the next time the service is requested, allowing for lazy initialization of the new service.
    ///
    /// - Note: If no service has been previously registered with the given type (and identifier, if provided),
    ///         this method will simply register the new service as if calling `register(as:identifier:using:)`.
    ///
    /// - Example:
    ///
    /// ```
    /// // Initial registration of a service
    /// ServiceLocator.register(as: MyServiceProtocol.self) {
    ///     RealService()
    /// }
    ///
    /// // Later in the application lifecycle, override the service with a mock version
    /// ServiceLocator.override(as: MyServiceProtocol.self) {
    ///     MockService()
    /// }
    /// ```
    ///
    /// This approach allows for flexible and dynamic replacement of services,
    /// facilitating easy testing and development of different components of your application.
    public static func override<T>(as type: T.Type, identifier: String? = nil, using factory: @autoclosure @escaping () -> T) {
        let key = identifier ?? String(describing: type.self)
        shared.serviceFactories[key] = factory
        shared.cache.removeValue(forKey: key)
    }
    
    /// Locates and returns an instance of the requested service.
    ///
    /// This method attempts to find a service that matches the specified type and optional identifier.
    /// If a service is found in the cache, it is returned immediately to improve performance.
    /// If the service is not found in the cache, it attempts to create a new instance using the factory closure
    /// provided during registration. The newly created service instance is then cached for future use.
    ///
    /// If no service matching the type and identifier is registered, this method throws an error.
    ///
    /// - Parameters:
    ///   - type: The type of the service to locate. It must conform to the expected protocol or class type.
    ///   - identifier: An optional unique identifier for the service. Use this if you have multiple instances
    ///                 of the same service type registered and need to distinguish between them.
    ///
    /// - Returns: An instance of the requested service.
    ///
    /// - Throws: `ServiceLocatorError.serviceNotFound` if no service matching the type and identifier is found.
    ///
    /// - Example:
    ///
    /// ```
    /// do {
    ///     let service: MyServiceProtocol = try ServiceLocator.locateService(ofType: MyServiceProtocol.self)
    ///     service.performAction()
    /// } catch ServiceLocatorError.serviceNotFound(let serviceName) {
    ///     print("Service \(serviceName) not found.")
    /// } catch {
    ///     print("Unexpected error: \(error).")
    /// }
    /// ```
    public static func locateService<T>(ofType type: T.Type, withIdentifier identifier: String? = nil) throws -> T {
        let key = identifier ?? String(describing: type.self)
        if let cached = shared.cache[key] as? T {
            return cached
        }
        guard let service = shared.serviceFactories[key]?() as? T else {
            throw ServiceLocatorError.serviceNotFound(key)
        }
        shared.cache[key] = service
        return service
    }
    
    /// Clears the cached instances of services.
    public static func clearCache() {
        shared.cache.removeAll()
        shared.serviceFactories.removeAll()
    }
    
    /// Unregisters a service with an optional identifier.
    /// - Parameters:
    ///   - type: The type of the service to unregister.
    ///   - identifier: An optional unique identifier for the service.
    public static func unregister<T>(type: T.Type, identifier: String? = nil) {
        let key = identifier ?? String(describing: type.self)
        // Elimina la fábrica del servicio y cualquier instancia en caché.
        shared.serviceFactories.removeValue(forKey: key)
        shared.cache.removeValue(forKey: key)
    }
}
