import Vapor
import Fluent

struct Todo: Model {
    var id: Node?

    var title: String?
    var completed: Bool
    var order: Int?
}

extension Todo: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        title = node["title"]?.string
        completed = node["completed"]?.bool ?? false
        order = node["order"]?.int
    }

    func makeNode() throws -> Node {
        return try Node(node:
            [
                "id": id,
                "title": title,
                "completed": completed,
                "order": order
            ]
        )
    }
}

extension Todo: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("todos") { users in
            users.id()
            users.string("title", optional: true)
            users.bool("completed")
            users.int("order", optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}
