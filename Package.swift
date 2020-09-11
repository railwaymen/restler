// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Restler",
    products: [
        .library(
            name: "Restler",
            targets: ["Restler"]),
        .library(
            name: "RxRestler",
            targets: ["RxRestler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.1.1")),
    ],
    targets: [
        .target(
            name: "Restler",
            dependencies: []),
        .target(
            name: "RxRestler",
            dependencies: [
                "Restler",
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "RestlerTests",
            dependencies: ["Restler"])
    ]
)
