# Service Injector

Service Injector is a lightweight, powerful dependency injection framework designed for Swift applications. It simplifies the management and instantiation of services throughout your app, promoting loose coupling, easier testing, and more modular code.

## Features

- **Simple API**: Easy to use and understand, with a minimal learning curve.
- **Swift Property Wrappers**: Utilizes Swift's property wrapper feature to inject dependencies cleanly.
- **Service Lifecycle Management**: Register, override, and unregister services dynamically.
- **Caching Mechanism**: Improves performance by caching instances of your services.
- **Type Safety**: Leverages Swift's type system to ensure that services are correctly resolved.

## Installation

### Swift Package Manager

You can add Service Injector to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages** > **Add Package Dependency...**
2. Enter the Service Injector repository URL: `https://github.com/macward/service-injector.git`
3. Follow the prompts to add the dependency.

```swift
dependencies: [
    .package(url: "https://github.com/macward/service-injector.git", .upToNextMajor(from: "1.1.0"))
]
```
and add Target
```swift
.product(name: "ServiceInjector", package: "ServiceInjector")
```

## Usage

### Registering Services

Register your services with the `ServiceLocator` to make them available for injection:

```swift
ServiceLocator.register(as: MyServiceProtocol.self, using: MyServiceImpl())
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
### Unregistering Services
If needed, you can unregister services:
```swift
ServiceLocator.unregister(type: MyServiceProtocol.self)
```

## Advanced Usage
For more advanced scenarios, such as registering multiple instances of the same service type or overriding existing registrations, refer to the documentation in the code.

## License
Service Injector is released under the MIT license. See LICENSE for more information.
