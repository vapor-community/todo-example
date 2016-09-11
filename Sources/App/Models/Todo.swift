import Vapor
import Fluent

// MARK: Model

struct Todo: Model {
    var id: Node?

    var title: String?
    var completed: Bool?
    var order: Int?
}

// MARK: NodeConvertible

extension Todo: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        title = node["title"]?.string
        completed = node["completed"]?.bool
        order = node["order"]?.int
    }

    func makeNode() throws -> Node {
        // model won't always have value to allow proper merges, 
        // database defaults to false
        let complete = completed ?? false
        return try Node.init(node:
            [
                "id": id,
                "title": title,
                "completed": complete,
                "order": order
            ]
        )
    }
}

// MARK: Database Preparations

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

// MARK: Merge

extension Todo {
    mutating func merge(updates: Todo) {
        id = updates.id ?? id
        completed = updates.completed ?? completed
        title = updates.title ?? title
        order = updates.order ?? order
    }
}
