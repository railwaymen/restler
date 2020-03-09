// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Restler",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Restler",
            targets: ["Restler"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Restler",
            dependencies: []),
        .testTarget(
            name: "RestlerTests",
            dependencies: ["Restler"]),
        .testTarget(
            name: "RestlerMockingTests",
            dependencies: ["Restler"])
    ]
)
