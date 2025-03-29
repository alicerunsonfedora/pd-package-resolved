// swift-tools-version: 6.0

import Foundation
import PackageDescription

let pdSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .unsafeFlags([
        "-whole-module-optimization",
        "-Xfrontend", "-disable-objc-interop",
        "-Xfrontend", "-disable-stack-protector",
        "-Xfrontend", "-function-sections",
        "-Xfrontend", "-gline-tables-only",
        "-Xcc", "-DTARGET_EXTENSION",
        "-Xcc", "-I", "-Xcc",
        "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1/include",
        "-Xcc", "-I", "-Xcc",
        "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1/include-fixed",
        "-Xcc", "-I", "-Xcc",
        "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1/../../../../arm-none-eabi/include",
        "-I",
        "\(Context.environment["PLAYDATE_SDK_PATH"] ?? "\(Context.environment["HOME"]!)/Developer/PlaydateSDK/")/C_API",
    ]),
]

let package = Package(
    name: "PackageResolved",
    platforms: [.macOS(.v14)],
    products: [
//        .library(name: "Charolette", targets: ["Charolette"]),
//        .library(name: "KDL", targets: ["KDL"]),
        .library(name: "PackageResolved", targets: ["PackageResolved"]),
    ],
    dependencies: [
        .package(url: "https://github.com/finnvoor/PlaydateKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Charolette",
            swiftSettings: pdSettings),
        .target(
            name: "KDL",
            exclude: ["src/utils", "doc", "bindings", "tests"],
            swiftSettings: pdSettings),
        .target(
            name: "PackageResolved",
            dependencies: [
                "Charolette",
                "KDL",
                .product(name: "PlaydateKit", package: "PlaydateKit")
            ],
            swiftSettings: pdSettings),
    ],
    swiftLanguageModes: [.v6]
)
