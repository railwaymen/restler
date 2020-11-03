// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ReleaseTool",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/console-kit.git", .upToNextMajor(from: "4.2.4")),
    ],
    targets: [
        .target(
            name: "ReleaseTool",
            dependencies: [
                .product(name: "ConsoleKit", package: "console-kit")
            ]),
    ]
)
