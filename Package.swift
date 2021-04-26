// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AckeePublishPlugin",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AckeePublishPlugin",
            targets: ["AckeePublishPlugin"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AckeePublishPlugin",
            dependencies: ["Publish"]),
        .testTarget(
            name: "AckeePublishPluginTests",
            dependencies: ["AckeePublishPlugin", "Publish"]),
    ]
)
