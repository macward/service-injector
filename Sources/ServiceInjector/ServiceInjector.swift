// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@propertyWrapper
public struct Injector<T>{
    public var wrappedValue: T
    public init(_ lifecycle: ServiceLifecycle = .runtime, id: String? = nil) {
        self.wrappedValue = ServiceLocator.locateService(ofType: T.self, withIdentifier: id, lifecycle: lifecycle)
    }
}
