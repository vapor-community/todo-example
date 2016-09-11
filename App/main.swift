import Vapor
import VaporMySQL

let drop = Droplet(preparations: [Todo.self], providers: [VaporMySQL.Provider.self])
drop.middleware.append(CorsMiddleware())

drop.get { _ in try drop.view.make("welcome.html") }
drop.get("tests") { _ in try drop.view.make("todo-backend-tests.html") }
drop.resource("todos", TodoController())

drop.serve()
