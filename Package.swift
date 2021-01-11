// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ORImageGallery",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ORImageGallery",
            targets: ["ORImageGallery"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "PureLayout",
                 url: "https://github.com/PureLayout/PureLayout",
                 from: "3.0.2"),
        .package(name: "SDWebImage",
                 url: "https://github.com/SDWebImage/SDWebImage",
                 from: "5.10.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ORImageGallery",
            dependencies: ["PureLayout", "SDWebImage"]),
        .testTarget(
            name: "ORImageGalleryTests",
            dependencies: ["ORImageGallery"]),
    ]
)