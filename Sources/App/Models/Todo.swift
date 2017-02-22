import Vapor
import Fluent
import VaporFluent

// MARK: Model

final class Todo: Model, NodeConvertible {
    let storage = Storage()

    var title: String?
    var completed: Bool?
    var order: Int?

    init(node: Node, in context: Context) {
        title = node["title"]?.string
        completed = node["completed"]?.bool
        order = node["order"]?.int

        id = node[idKey]
    }

    func makeNode(context: Context) throws -> Node {
        var node = Node([:])
        try node.set("id", id)
        try node.set("title", title)
        // model won't always have value to allow proper merges,
        // database defaults to false
        try node.set("completed", completed ?? false)
        try node.set("order", order)
        return node
    }
}

// MARK: Database Preparations

extension Todo: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(entity) { todos in
            todos.id(for: Todo.self)
            todos.string("title", optional: true)
            todos.bool("completed")
            todos.int("order", optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}

// MARK: Merge

extension Todo {
    func merge(updates: Todo) {
        id = updates.id ?? id
        completed = updates.completed ?? completed
        title = updates.title ?? title
        order = updates.order ?? order
    }
}
