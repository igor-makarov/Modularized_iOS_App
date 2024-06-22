// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Submodules",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DomainMock", targets: ["DomainMock"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "RecipesScreen", targets: ["RecipesScreen"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    targets: [
        .target(name: "DomainMock"),
        .target(name: "Domain"),
        .target(name: "Data"),
        .target(name: "RecipesScreen"),
        .target(name: "Networking"),
        .target(name: "DesignSystem")
    ]
)
