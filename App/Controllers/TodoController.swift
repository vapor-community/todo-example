import HTTP
import Vapor

final class TodoController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Todo.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var todo = try request.todo()
        try todo.save()
        return todo
    }

    func show(request: Request, todo: Todo) throws -> ResponseRepresentable {
        return todo
    }

    func delete(request: Request, todo: Todo) throws -> ResponseRepresentable {
        try todo.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Todo.deleteAll()
        return JSON([])
    }

    func update(request: Request, existing: Todo) throws -> ResponseRepresentable {
        var new = try request.todo()
        new.merge(existing: existing)
        try new.update()
        return new
    }

    func replace(request: Request, todo: Todo) throws -> ResponseRepresentable {
        try todo.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Todo> {
        return Resource(
            index: self.index,
            store: self.create,
            show: self.show,
            replace: self.replace,
            modify: self.update,
            destroy: self.delete,
            clear: self.clear
        )
    }
}

extension Request {
    fileprivate func todo() throws -> Todo {
        guard let todo = try json.flatMap({ try Todo(node: $0) }) else {
            throw Abort.notFound
        }
        return todo
    }
}

extension Todo {
    fileprivate mutating func merge(existing: Todo) {
        id = id ?? existing.id
        // completed is always self
        title = title ?? existing.title
        order = order ?? existing.order
    }
}

extension Model {
    static func deleteAll() throws {
        try Self.query().delete()
    }

    func update() throws {
        try type(of: self).query().createOrModify(makeNode())
    }
}
