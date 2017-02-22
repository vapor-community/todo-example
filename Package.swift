import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 0),
        .Package(url: "https://github.com/vapor/sqlite-driver.git", Version(2,0,0, prereleaseIdentifiers: ["alpha"])),
    ],
    exclude: [
        "Config",
        "Deploy",
        "Public",
        "Resources",
        "Tests",
        "Database"
    ]
)
