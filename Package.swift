// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Tropos",
    targets: [
        .target(name: "acknowledge", dependencies: ["Settings"], path: "bin/acknowledge"),
        .target(name: "Settings"),
    ]
)
