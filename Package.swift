// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIKitEx",
    platforms: [
        .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
    ],
    products: [
        .library(
            name: "UIKitEx",
            targets: ["UIKitEx"]),
    ],
    dependencies: [
        .package(name: "FoundationEx", url: "https://github.com/RocketLaunchpad/FoundationEx.git", .branch("main")),
        .package(name: "CombineEx", url: "https://github.com/RocketLaunchpad/CombineEx.git", .branch("main")),
        .package(name: "ReducerArchitecture", url: "https://github.com/RocketLaunchpad/ReducerArchitecture.git", .branch("master")),
        .package(name: "Functional", url: "https://github.com/RocketLaunchpad/Functional.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "UIKitEx",
            dependencies: ["FoundationEx", "CombineEx", "ReducerArchitecture", "Functional"],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend",
                "-warn-long-function-bodies=100",
                "-Xfrontend",
                "-warn-long-expression-type-checking=100"
            ])]
        ),
        .testTarget(
            name: "UIKitExTests",
            dependencies: ["UIKitEx"]
        )
    ]
)
