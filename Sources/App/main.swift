import URI
import HTTP
import Vapor
import VaporMySQL

let drop = Droplet()
drop.middleware.append(CorsMiddleware())
drop.preparations.append(Todo.self)

try drop.addProvider(VaporMySQL.Provider.self)

// MARK: Landing Pages

drop.get { _ in try drop.view.make("welcome") }

// MARK: Tests Redirect

drop.get("tests") { request in
    guard let baseUrl = request.baseUrl else { throw Abort.badRequest }
    let todosUrl = baseUrl + "todos"
    return Response(redirect: "http://todobackend.com/specs/index.html?\(todosUrl)")
}

// MARK: /todos/

drop.grouped(TodoURLMiddleware()).resource("todos", TodoController())

// MARK: Serve

drop.run()
