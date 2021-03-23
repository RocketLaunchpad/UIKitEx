// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIKitEx",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "UIKitEx",
            targets: ["UIKitEx"]),
    ],
    dependencies: [
        .package(name: "FoundationEx", url: "https://github.com/RocketLaunchpad/FoundationEx.git", from: "1.0.0"),
        .package(name: "CombineEx", url: "https://github.com/RocketLaunchpad/CombineEx.git", from: "1.0.0"),
        .package(name: "ReducerArchitecture", url: "https://github.com/RocketLaunchpad/ReducerArchitecture.git", from: "1.0.0"),
        // .package(name: "Functional", url: "https://github.com/RocketLaunchpad/Functional.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "UIKitEx",
            dependencies: ["FoundationEx", "CombineEx", "ReducerArchitecture"]
        ),
        .testTarget(
            name: "UIKitExTests",
            dependencies: ["UIKitEx"]
        )
    ]
)
