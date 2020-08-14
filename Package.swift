// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Restler",
    platforms: [
        .iOS(.v10),
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
            dependencies: ["Restler"])
    ]
)
