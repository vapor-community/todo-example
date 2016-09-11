import Vapor
import HTTP
import VaporMySQL
import MySQL

let app = Droplet(preparations: [Todo.self], providers: [VaporMySQL.Provider.self])
app.middleware.append(CorsMiddleware())

/**
	This first route will return the welcome.html
	view to any request to the root directory of the website.

	Views referenced with `app.view` are by default assumed
	to live in <workDir>/Resources/Views/

	You can override the working directory by passing
	--workDir to the application upon execution.
*/
app.get { _ in try app.view.make("welcome.html") }
app.get("tests") { _ in try app.view.make("todo-backend-tests.html") }
print("T: \(type(of: app.database!))")
app.resource("todos", TodoController())
/**
	This will set up the appropriate GET, PUT, and POST
	routes for basic CRUD operations. Check out the
	TodoController in App/Controllers to see more.

	Controllers are also type-safe, with their types being
	defined by which StringInitializable class they choose
	to receive as parameters to their functions.
*/
// app.resource("todos", controller: TodoController.self)

/**
	Middleware is a great place to filter
	and modifying incoming requests and outgoing responses.

	Check out the middleware in App/Middelware.

	You can also add middleware to a single route by
	calling the routes inside of `app.middleware(MiddelwareType) {
		app.get() { ... }
	}`
*/
// app.middleware.append(CorsMiddleware())

// Print what link to visit for default port
app.serve()
