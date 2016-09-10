import Vapor
/*
class TodoController: Controller {
    typealias Item = Todo
    
    private let todoDao:TodoDao?

    required init(application: Application) {
        do {
            try todoDao = TodoDaoImpl()
        }
        catch {
            Log.error("Could not initialize Todo Dao")
            todoDao = nil
        }
        Log.info("Todo controller created")
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let todos = todoDao.findAllTodos() {
                return Json.array(todos.map({ (todo:Todo) -> Json in
                    todo.url = "http://\(request.uri.host!)/todos/\(todo.id!)"
                    return todo.makeJson()
                }))
            } else {
                throw Abort.internalServerError
            }
        } else {
            throw Abort.internalServerError
        }
    }

    func store(_ request: Request) throws -> ResponseRepresentable {
        guard let title = request.data["title"]?.string else {
            throw Abort.badRequest
        }
        if let todoDao = todoDao {
            var completed:Bool
            if request.data["completed"] != nil && request.data["completed"]!.bool != nil {
                completed = request.data["completed"]!.bool!
            } else {
                completed = false
            }
            if let todo = todoDao.createTodo(Todo(id: nil, title: title, completed: completed, order: request.data["order"].int)){
                todo.url = "http://\(request.uri.host!)/todos/\(todo.id!)"
                return todo
            } else {
                throw Abort.internalServerError
            }
        } else {
            throw Abort.internalServerError
        }
    }

    /**
    	Since item is of type Todo,
    	only instances of todo will be received
    */
    func show(_ request: Request, item todo: Todo) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let id = todo.id {
                if let todo = todoDao.getTodoWithId(id) {
                    todo.url = "http://\(request.uri.host!)/todos/\(todo.id!)"
                    return todo
                } else {
                    throw Abort.notFound
                }
            } else {
                throw Abort.badRequest
            }
        } else {
            throw Abort.internalServerError
        }
    }

    func update(_ request: Request, item todo: Todo) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let id = todo.id, let title = request.data["title"]?.string, let completed = request.data["completed"]?.bool, let order = request.data["order"]?.int {
                let todoToUpdate = Todo(id: id, title: title, completed: completed, order: order)
                if let updatedTodo = todoDao.updateTodo(todoToUpdate) {
                    updatedTodo.url = "http://\(request.uri.host!)/todos/\(updatedTodo.id!)"
                    return updatedTodo
                } else {
                    throw Abort.notFound
                }
            } else {
                throw Abort.badRequest
            }
        } else {
            throw Abort.internalServerError
        }
    }
    
    func modify(_ request: Request, item todo: Todo) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let id = todo.id {
                var changes:[String:Any] = [String:Any]()
                if let title = request.data["title"]?.string {
                    changes["title"] = title
                    Log.info("Changing title of todo \(todo.id!) to '\(title)'")
                }
                if let completed = request.data["completed"]?.bool {
                    changes["completed"] = completed
                }
                if let order = request.data["order"]?.int {
                    changes["order"] = order
                }
                if let updatedTodo = todoDao.modifyTodoWithId(id, changes: changes) {
                    updatedTodo.url = "http://\(request.uri.host!)/todos/\(updatedTodo.id!)"
                    return updatedTodo
                } else {
                    throw Abort.notFound
                }
            } else {
                throw Abort.badRequest
            }
        } else {
            throw Abort.internalServerError
        }
    }

    func destroy(_ request: Request, item todo: Todo) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let id = todo.id {
                todoDao.deleteTodoWithId(id)
                return ""
            } else {
                throw Abort.notFound
            }
        } else {
            throw Abort.internalServerError
        }
    }

    func destroyAll(_ request: Request) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            todoDao.deleteAllTodos()
            return ""
        } else {
            throw Abort.internalServerError
        }
    }
}
*/
