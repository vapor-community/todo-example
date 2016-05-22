import Vapor
import MongoKitten

final class Todo {
    var id: String?
    var title: String?
    var completed: Bool = false
    var order:Int?
    
    var url:String? {
        if let id = id {
            return "http://localhost:8080/todos/\(id)"
        } else {
            return nil
        }
    }
    
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
        self.init(id:bson["_id"].string, title: bson["title"].string, completed: bson["completed"].bool, order:bson["order"].int)
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
