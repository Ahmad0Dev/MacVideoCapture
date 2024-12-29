// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MacVideoCapture",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "MacVideoCapture", targets: ["MacVideoCapture"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacVideoCapture",
            dependencies: [],
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
)
