//
//  TodoDaoImpl.swift
//  VaporApp
//
//  Created by Sebastien Arbogast on 16/05/2016.
//
//

import Foundation
import MongoKitten
import Vapor

class TodoDaoImpl: TodoDao {
    let collectionName = "todos"
    
    private let collection:MongoKitten.Collection
    
    init() throws {
        if let repository = MongoRepository.sharedRepository {
            self.collection = repository.database[collectionName]
        } else {
            throw MongoRepositoryError.CouldNotConnect
        }
    }
    
    func createTodo(_ todo:Todo) -> Todo? {
        do {
            let documentToInsert = todo.makeBson()
            let todoDocument = try self.collection.insert(documentToInsert)
            return try Todo(fromBson:todoDocument)
        } catch MongoError.InsertFailure(documents: _, error: let error) {
            Log.error("Could not insert todo because " + (error?["errmsg"].string)!)
            return nil
        } catch {
            Log.error("Error converting todo to BSON")
            return nil
        }
    }
    
    func findAllTodos() -> [Todo]? {
        do {
            var todos = [Todo]()
            let resultTodos = try self.collection.find()
            
            for result in resultTodos {
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
    
    func updateTodo(_ todo: Todo) -> Todo? {
        do {
            if let id = todo.id {
                try self.collection.update(matching: "_id" == ObjectId(id), to: todo.makeBson())
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
}