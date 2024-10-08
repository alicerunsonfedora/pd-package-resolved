// swift-tools-version: 5.9

import Foundation
import PackageDescription


#if os(macOS)
let gccIncludePrefix =
    "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"
#else
// Note: this may change depending on how the ARM GNU toolchain is installed.
let gccIncludePrefix = "/usr/local/share/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/lib"
#endif

guard let home = Context.environment["HOME"] else {
    fatalError("could not determine home directory")
}
let package = Package(
    name: "PlaydateKit",
    products: [.library(name: "PlaydateKit", targets: ["PlaydateKit"])],
    targets: [
        .target(name: "PlaydateKit", dependencies: ["CPlaydate"], swiftSettings: [
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
                "-I", "\(home)/Developer/PlaydateSDK/C_API"
            ]),
        ]),
        .target(name: "CPlaydate", cSettings: [
            .unsafeFlags([
                "-DTARGET_EXTENSION",
                "-I", "\(gccIncludePrefix)/include",
                "-I", "\(gccIncludePrefix)/include-fixed",
                "-I", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
                "-I", "\(home)/Developer/PlaydateSDK/C_API",
            ])
        ]),
    ]
)
