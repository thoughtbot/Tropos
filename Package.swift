// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Tropos",
    targets: [
        .target(name: "generate-acknowledgements", dependencies: ["Settings"]),
        .target(name: "Settings"),
    ]
)
