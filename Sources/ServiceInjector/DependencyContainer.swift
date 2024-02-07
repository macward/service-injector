//
//  File.swift
//  
//
//  Created by Max on 06/02/2024.
//

import Foundation

public enum ServiceLifecycle {
    case singleton, runtime
}

public protocol DependencyRegister {
    static func load()
}

public final class ServiceLocator {
    
    private var cache: [String: Any] = [:]
    private var serviceFactories: [String: () -> Any] = [:]
    private static let shared = ServiceLocator()
    
    // Método para registrar servicios
    public static func register<T>(as type: T.Type, withLifecycle lifecycle: ServiceLifecycle, identifier: String? = nil, using factory: @autoclosure @escaping () -> T) {
        let key = identifier ?? String(describing: type.self)
        shared.serviceFactories[key] = factory
        if lifecycle == .singleton {
            shared.cache[key] = factory()
        }
    }
    
    // Método para localizar servicios
    public static func locateService<T>(ofType type: T.Type, withIdentifier identifier: String? = nil, lifecycle: ServiceLifecycle = .runtime) -> T {
        let key = identifier ?? String(describing: type.self)
        switch lifecycle {
        case .singleton:
            guard let service = shared.cache[key] as? T else {
                fatalError("\(key): Singleton service not found. Please register the service first with an identifier if needed.")
            }
            return service
        case .runtime:
            guard let service = shared.serviceFactories[key]?() as? T else {
                fatalError("\(key): Service not found. Please register the service first with an identifier if needed.")
            }
            return service
        }
    }
}
