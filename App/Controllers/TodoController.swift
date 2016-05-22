import Vapor

class TodoController: Controller {
    typealias Item = Todo
    
    private let todoDao:TodoDao?

    required init(application: Application) {
        Log.info("Todo controller created")
        do {
            try todoDao = TodoDaoImpl()
        }
        catch {
            print("Could not initialize Todo Dao")
            todoDao = nil
        }
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let todos = todoDao.findAllTodos() {
                return Json.array(todos.map({ (todo:Todo) -> Json in
                    todo.makeJson()
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
        //Todo is JsonRepresentable
        return todo.makeJson()
    }
    
    func modify(_ request: Request, item todo: Todo) throws -> ResponseRepresentable {
        if let todoDao = todoDao {
            if let id = todo.id {
                var changes:[String:AnyObject] = [String:AnyObject]()
                if let title = request.data["title"] {
                    changes["title"] = title.string
                }
                if let completed = request.data["completed"] {
                    changes["completed"] = completed.bool
                }
                if let order = request.data["order"] {
                    changes["order"] = order.int
                }
                if let updatedTodo = todoDao.modifyTodoWithId(id, changes: changes) {
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
