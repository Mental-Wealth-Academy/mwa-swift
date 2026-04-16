// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MentalWealthAcademy",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/privy-io/privy-ios", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "MentalWealthAcademy",
            dependencies: [
                .product(name: "Privy", package: "privy-ios"),
            ],
            path: "Sources",
            resources: [
                .process("App/Assets.xcassets"),
                .copy("App/Fonts"),
            ]
        ),
    ]
)
