import Vapor
import Fluent

struct Todo: Model {
    var id: Node?

    var title: String
    var completed: Bool
    var order: Int?
}

extension Todo: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        title = try node.extract("title")
        completed = node["completed"]?.bool ?? false
        order = node["order"]?.int
    }

    func makeNode() throws -> Node {
        return try Node.init(node:
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
        fatalError("unimplemented")
    }
}

/*
import MongoKitten
*/
/*
final class Todo {
    var id: String?
    var title: String?
    var completed: Bool = false
    var order:Int?
    var url:String?
    
    init(id:String? = nil, title:String? = nil, completed:Bool = false, order:Int? = nil) {
        self.title = title
        self.id = id
        self.completed = completed
        self.order = order
    }
}

/**
	This allows instances of Todo to be
	passed into Json arrays and dictionaries
	as if it were a native JSON type.
*/
extension Todo: JsonRepresentable {
    func makeJson() -> Json {
        var json = Json(["completed":completed])
        if let url = url {
            json["url"] = .string(url)
        }
        if let id = id {
            json["id"] = .string(id)
        }
        if let title = title {
            json["title"] = .string(title)
        }
        if let order = order {
            json["order"] = .number(Double(order))
        }
        return json
    }
}

/**
	If a data structure is StringInitializable,
	it's Type can be passed into type-safe routing handlers.
*/
extension Todo: StringInitializable {
    convenience init?(from string: String) throws {
        self.init(id: string)
    }
}

extension Todo {
    convenience init?(fromBson bson:Document) throws {
        let todoId = bson["_id"].string
        self.init(id:todoId, title: bson["title"].string, completed: bson["completed"].bool, order:bson["order"].int)
    }
    
    func makeBson() -> Document {
        var bson = [
            "completed": ~self.completed
        ] as Document
        
        if let title = self.title {
            bson["title"] = ~title
        }
        if let id = self.id {
            bson["objectID"] = .objectId(try! ObjectId(id))
        }
        if let order = self.order {
            bson["order"] = ~order
        }
        return bson
    }
}
*/
