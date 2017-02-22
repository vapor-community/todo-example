import URI
import HTTP
import Vapor
import FluentSQLite
import Fluent
import VaporFluent

let drop = Droplet()

// Using Fluent
try drop.addProvider(VaporFluent.Provider.self)
drop.preparations.append(Todo.self)

// Configure Database
//let sqldb = drop.resourcesDir + "Tests/SQLite/database.sqlite"
let sqlDriver = try SQLiteDriver(path: ":memory:")
drop.database = Database(sqlDriver)

// CORS Middleware
drop.middleware.append(CORSMiddleware())

// MARK: Landing Pages

drop.get { _ in try drop.view.make("welcome.html") }

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
