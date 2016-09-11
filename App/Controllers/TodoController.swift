import HTTP
import Vapor
import MySQL
import FluentMySQL
import Fluent

var count = 0
extension Todo {
    func makeJson(with request: Request) throws -> JSON {
        let node = try makeNode()
        return try node.makeJson(with: request)
    }
}

extension Node {
    func makeJson(with request: Request) throws -> JSON {
        guard let id = self["id"]?.string else {
            throw Abort.notFound
        }
        guard let host = request.headers["Host"]?.finished(with: "/") else { throw Abort.notFound }
        var node = self
        node["url"] = "\(request.uri.scheme)://\(host)todos/\(id)".makeNode()
        return try node.converted()
    }
}

extension Todo {
    mutating func merge(existing: Todo) {
        id = id ?? existing.id
        // completed is always self
        order = order ?? existing.order
    }
}

final class TodoController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        let json = try Todo.all().map { try $0.makeJson(with: request) }
        return JSON(json)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        guard
            var todo = try request.json.flatMap({ try Todo(node: $0) })
            else {
                throw Abort.notFound
            }

        try todo.save()
        return try todo.makeJson(with: request)
    }

    func show(request: Request, todo: Todo) throws -> ResponseRepresentable {
        return try todo.makeJson(with: request)
    }

    func delete(request: Request, todo: Todo) throws -> ResponseRepresentable {
        try todo.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Todo.query().delete()
        return JSON([])
    }

    func update(request: Request, todo: Todo) throws -> ResponseRepresentable {
        guard
            var new = try request.json.flatMap({ try Todo(node: $0) })
            else {
                throw Abort.notFound
            }
        new.merge(existing: todo)
        try Todo.query().createOrModify(new.makeNode())
        return try new.makeJson(with: request)
    }

    func replace(request: Request, todo: Todo) throws -> ResponseRepresentable {
        try todo.delete()
        return try create(request: request)
    }

    lazy var resource: Resource<Todo> = Resource(
        index: self.index,
        store: self.create,
        show: self.show,
        replace: self.replace,
        modify: self.update,
        destroy: self.delete,
        clear: self.clear,
        aboutItem: nil,
        aboutMultiple: nil
    )

    func makeResource() -> Resource<Todo> {
        return resource
    }
}
