// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

#if os(macOS)
let gccIncludePrefix =
    "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"
#else
// Note: this may change depending on how the ARM GNU toolchain is installed.
let gccIncludePrefix = "/usr/lib/gcc/arm-none-eabi/10.3.1"
#endif

guard let home = Context.environment["HOME"] else {
    fatalError("could not determine home directory")
}

let swiftSettingsSimulator: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .unsafeFlags([
        "-Xfrontend", "-disable-objc-interop",
        "-Xfrontend", "-disable-stack-protector",
        "-Xfrontend", "-function-sections",
        "-Xfrontend", "-gline-tables-only",
        "-Xcc", "-DTARGET_EXTENSION",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
        "-I", "\(home)/Developer/PlaydateSDK/C_API",
    ]),
]

let package = Package(
    name: "PackageResolved",
    products: [
        .library(name: "Charolette", targets: ["Charolette"]),
        .library(name: "PackageResolved", targets: ["PackageResolved"]),
    ],
    dependencies: [
        .package(name: "PlaydateKit", path: "../PlaydateKit"),
    ],
    targets: [
        .target(name: "Charolette"),
        .target(
            name: "PackageResolved",
            dependencies: [
                // .product(name: "CPlaydate", package: "PlaydateKit"),
                .product(name: "PlaydateKit", package: "PlaydateKit"),
                "Charolette"
            ],
            swiftSettings: swiftSettingsSimulator
        ),
        .testTarget(name: "CharoletteTests", dependencies: ["Charolette"])
    ]
)
