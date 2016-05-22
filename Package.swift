import PackageDescription

let package = Package(
    name: "VaporApp",
    dependencies: [
        .Package(url: "https://github.com/sarbogast/vapor.git", majorVersion: 0, minor: 11),
        .Package(url: "https://github.com/PlanTeam/MongoKitten.git", majorVersion: 0, minor: 9),
    ],
    exclude: [
        "Deploy",
        "Public",
        "Resources",
		"Tests",
		"Database"
    ]
)
