import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 18),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 0, minor: 6)
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
