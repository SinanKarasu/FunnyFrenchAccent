// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FunnyFrenchCore",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(name: "FunnyFrenchCore", targets: ["FunnyFrenchCore"])
    ],
    targets: [
        .target(
            name: "FunnyFrenchCore",
            path: "FunnyFrenchAccent/FunnyFrenchCore"
        ),
        .testTarget(
            name: "FunnyFrenchCoreTests",
            dependencies: ["FunnyFrenchCore"]
        )
    ]
)
