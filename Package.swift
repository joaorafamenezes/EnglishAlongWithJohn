// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EnglishAlongWithJohn",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "EnglishAlongWithJohn",
            targets: ["EnglishAlongWithJohn"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EnglishAlongWithJohn",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "EnglishAlongWithJohnTests",
            dependencies: ["EnglishAlongWithJohn"],
            path: "Tests"
        )
    ]
)
