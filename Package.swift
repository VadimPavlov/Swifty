// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swifty",
    platforms: [.iOS(.v9), .macOS(.v10_11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyIOS",
            targets: ["SwiftyIOS", "SwiftyCommon"]),
        .library(
            name: "SwiftyOSX",
            targets: ["SwiftyOSX", "SwiftyCommon"])

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyCommon",
            path: "Sources/Swifty/Common",
            dependencies: []),
        .target(
            name: "SwiftyIOS",
            path: "Sources/Swifty/ios",
            dependencies: []),
        .target(
            name: "SwiftyOSX",
            path: "Sources/Swifty/osx",
            dependencies: []),
    ]
)
