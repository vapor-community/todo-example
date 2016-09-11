import Vapor
import VaporMySQL

// MARK: Initialize Droplet 

let drop = Droplet(preparations: [Todo.self], providers: [VaporMySQL.Provider.self])

// MARK: Cors Headers

drop.middleware.append(CorsMiddleware())

// MARK: Landing Pages

drop.get { _ in try drop.view.make("welcome") }
drop.get("tests") { _ in try drop.view.make("todo-backend-tests") }

// MARK: /todos/

drop.grouped(TodoURLMiddleware()).resource("todos", TodoController())

// MARK: Serve

drop.serve()
