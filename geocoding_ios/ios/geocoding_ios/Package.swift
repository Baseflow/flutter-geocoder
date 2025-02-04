// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "geocoding_ios",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "geocoding-ios", targets: ["geocoding_ios"])
    ],
    targets: [
        .target(
            name: "geocoding_ios",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                // TODO: Update your plugin name.
                .headerSearchPath("include/geocoding_ios")
            ]
        )
    ]
)
