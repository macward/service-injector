// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceInjector",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ServiceInjector",
            targets: ["ServiceInjector"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ServiceInjector"),
        .testTarget(
            name: "ServiceInjectorTests",
            dependencies: ["ServiceInjector"]),
    ]
)
