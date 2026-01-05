// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kaset",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "KasetLib",
            targets: ["KasetLib"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1")
    ],
    targets: [
        // Main library target containing all app code
        .target(
            name: "KasetLib",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle")
            ],
            path: ".",
            exclude: [
                "Tests",
                "Tools",
                "docs",
                "Kaset.xcodeproj",
                ".github",
                ".vscode",
                "Casks",
                "appcast.xml",
                "README.md",
                "AGENTS.md",
                "CONTRIBUTING.md",
                "LICENSE",
                "TEMP_PODCAST_PLAN.md",
                "TEMP_TEST_COVERAGE_PLAN.md",
                ".gitignore",
                ".swiftformat",
                ".swiftlint.yml",
                "App/Assets.xcassets",
                "App/Info.plist",
                "App/Kaset.entitlements",
                "App/Kaset.Debug.entitlements",
                "App/kaset.icon"
            ],
            sources: [
                "App/KasetApp.swift",
                "App/AppDelegate.swift",
                "Core",
                "Views"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        // Unit tests target
        .testTarget(
            name: "KasetTests",
            dependencies: ["KasetLib"],
            path: "Tests/KasetTests",
            exclude: [
                "Fixtures"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
