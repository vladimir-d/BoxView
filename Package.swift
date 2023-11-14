// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BoxView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BoxView",
            targets: ["BoxView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BoxView",
            exclude: ["BoxViewExample", "BoxViewTesting", "Docs", "BoxView.podspec"]
        ),
        .testTarget(
            name: "BoxViewTests",
            dependencies: ["BoxView"]),
    ]
)
