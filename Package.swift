// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Restler",
    products: [
        .library(
            name: "RestlerCore",
            targets: ["RestlerCore"]),
        .library(
            name: "RestlerCombine",
            targets: ["RestlerCombine"]),
        .library(
            name: "RxRestler",
            targets: ["RxRestler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.1.1")),
    ],
    targets: [
        .target(
            name: "RestlerCombine",
            dependencies: [
                .target(name: "RestlerCore"),
            ]),
        .target(
            name: "RestlerCore",
            dependencies: []),
        .target(
            name: "RxRestler",
            dependencies: [
                .target(name: "RestlerCore"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "RestlerTests",
            dependencies: ["RestlerCore", "RestlerCombine"])
    ]
)
