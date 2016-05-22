//
//  TodoDaoImpl.swift
//  VaporApp
//
//  Created by Sebastien Arbogast on 16/05/2016.
//
//

import Foundation
import MongoKitten

class TodoDaoImpl: MongoDaoBaseImpl, TodoDao {
    let collectionName = "todos"
    
    var iso8601:NSDateFormatter {
        let df = NSDateFormatter()
        let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        df.locale = enUSPOSIXLocale
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        df.timeZone = NSTimeZone(abbreviation: "UTC")
        return df
    }
    
    var collection:MongoKitten.Collection {
        return self.database[collectionName]
    }
    
    override init() throws {
        try super.init()
    }
    
    func createTodo(_ todo:Todo) -> Todo? {
        do {
            let now = NSDate()
            let creationDate = self.iso8601.string(from: now)
            todo.dateCreated = creationDate
            let documentToInsert = todo.makeBson()
            let todoDocument = try self.collection.insert(documentToInsert)
            return try Todo(fromBson:todoDocument)
        } catch MongoError.InsertFailure(documents: _, error: let error) {
            NSLog("Could not insert todo because " + (error?["errmsg"].string)!)
            return nil
        } catch {
            NSLog("Error converting todo to BSON")
            return nil
        }
    }
    
    func findAllTodos() -> [Todo]? {
        do {
            var todos = [Todo]()
            let resultTodos = try self.collection.find()
            
            /*.sorted(isOrderedBefore: { (doc1:Document, doc2:Document) -> Bool in
                return doc1["dateCreated"].string.compare(doc2["dateCreated"].string) == NSComparisonResult.orderedDescending
            })*/
            
            for result in resultTodos {
                let completed = result["completed"].boolValue
                print("completed:\(completed)")
                if let todo = try Todo(fromBson: result) {
                    todos.append(todo)
                }
            }
            return todos
        } catch {
            return nil
        }
    }
    
    func deleteAllTodos() {
        do {
            try self.collection.remove(matching: [] as Document)
        } catch {
            
        }
    }
    
    func getTodoWithId(_ id: String) -> Todo? {
        do {
            if let todoDocument = try self.collection.findOne(matching: "_id" == ObjectId(id)) {
                return try Todo(fromBson: todoDocument)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    func modifyTodoWithId(_ id: String, changes: [String : AnyObject]) -> Todo? {
        do {
            if var todoDocument = try self.collection.findOne(matching: "_id" == ObjectId(id)) {
                if let title = changes["title"] as? String {
                    todoDocument["title"] = ~title
                }
                if let completed = changes["completed"] as? Bool {
                    todoDocument["completed"] = ~completed
                }
                if let order = changes["order"] as? Int {
                    todoDocument["order"] = ~order
                }
                try self.collection.update(matching: "_id" == ObjectId(id), to: todoDocument)
                
                if let todoDocument = try self.collection.findOne(matching: "_id" == ObjectId(id)) {
                    return try Todo(fromBson: todoDocument)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func deleteTodoWithId(_ id: String) {
        do {
            try self.collection.remove(matching: "_id" == ObjectId(id))
        } catch {
            
        }
    }
}