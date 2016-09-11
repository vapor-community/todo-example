import HTTP

class CorsMiddleware: Middleware {
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        let response = try chain.respond(to: request)
        response.headers["Access-Control-Allow-Origin"] = "*";
        response.headers["Access-Control-Allow-Headers"] = "x-requested-with; origin; content-type; accept"
        response.headers["Access-Control-Allow-Methods"] = "POST; GET; PUT; OPTIONS; DELETE; PATCH"
        return response
	}
}
