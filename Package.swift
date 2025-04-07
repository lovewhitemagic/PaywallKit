// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PaywallKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "PaywallKit",
            targets: ["PaywallKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PaywallKit",
            dependencies: []
        )
    ]
)