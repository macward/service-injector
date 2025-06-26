# Service Injector

Service Injector is a lightweight, powerful dependency injection framework designed for Swift applications. It simplifies the management and instantiation of services throughout your app, promoting loose coupling, easier testing, and more modular code.

## Features

- **Simple API** – Minimal learning curve for registering and resolving services.
- **Thread‑Safe Registry** – All operations are synchronized, so services can be accessed from any queue.
- **Swift Property Wrappers** – `@Inject` and `@AsyncInject` provide clean syntax for retrieving services.
- **Service Lifecycle Management** – Choose between `.singleton` or `.runtime` lifecycles when registering.
- **Identifier‑Based Registration** – Register multiple implementations of the same protocol using identifiers.
- **Service Override and Unregister** – Replace or remove services at runtime; useful for testing.
- **Caching Mechanism** – Singleton services are cached for fast retrieval.
- **Type Safety** – The compiler ensures the correct type is returned for each request.

## Installation

### Swift Package Manager

You can add Service Injector to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages** > **Add Package Dependency...**
2. Enter the Service Injector repository URL: `https://github.com/macward/service-injector.git`
3. Follow the prompts to add the dependency.

```swift
dependencies: [
    .package(url: "https://github.com/macward/service-injector.git", .upToNextMajor(from: "1.0.0"))
]
```
and add Target
```swift
.product(name: "ServiceInjector", package: "ServiceInjector")
```

## Usage

### Registering Services

Register your services with the `ServiceLocator`. Specify the lifecycle (`.singleton` or `.runtime`) and optionally an identifier:

```swift
try ServiceLocator.register(as: MyServiceProtocol.self,
                            withLifecycle: .runtime,
                            using: MyServiceImpl())
```

### Injecting Services
Use the @Inject property wrapper to inject dependencies into your classes:
```swift
class MyViewController: UIViewController {
    @Inject var myService: MyServiceProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        myService.performAction()
    }
}
```

### Multiple Implementations
Register different implementations with identifiers and request them explicitly:

```swift
try ServiceLocator.register(as: MovieDataSource.self,
                            withLifecycle: .singleton,
                            identifier: "local",
                            using: LocalMovieDataSource())
try ServiceLocator.register(as: MovieDataSource.self,
                            withLifecycle: .runtime,
                            identifier: "remote",
                            using: RemoteMovieDataSource())

class MoviesViewModel {
    @Inject(identifier: "local") var localDatasource: MovieDataSource
    @Inject(identifier: "remote") var remoteDatasource: MovieDataSource
}
```

### Asynchronous Injection
`@AsyncInject` allows awaiting services with Swift concurrency:
```swift
class AsyncConsumer {
    @AsyncInject var myService: Task<MyServiceProtocol, Error>

    func load() async throws {
        let service = try await myService.value
        service.performAction()
    }
}
```

### Overriding Services
Swap a registered implementation with another one at runtime—useful for tests:

```swift
class MockService: MyServiceProtocol {}

ServiceLocator.override(as: MyServiceProtocol.self,
                        withLifecycle: .runtime,
                        using: MockService())
```

### Clearing the Cache
Remove all registered services and cached singletons:

```swift
ServiceLocator.clearCache()
```
### Unregistering Services
If needed, you can unregister services:
```swift
ServiceLocator.unregister(type: MyServiceProtocol.self)
```

## Advanced Usage
Services can be resolved directly if needed. The API supports both synchronous and asynchronous lookups:

```swift
let sync: MyServiceProtocol = try ServiceLocator.locateService(
    ofType: MyServiceProtocol.self,
    withLifecycle: .singleton,
    withIdentifier: "local")

let asyncService: MyServiceProtocol = try await ServiceLocator.locateServiceAsync(
    ofType: MyServiceProtocol.self,
    withLifecycle: .runtime)
```

## License
Service Injector is released under the MIT license. See LICENSE for more information.
