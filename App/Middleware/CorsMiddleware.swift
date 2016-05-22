//
//  CorsMiddleware.swift
//  VaporApp
//
//  Created by Sebastien Arbogast on 15/05/2016.
//
//

import Vapor

class CorsMiddleware: Middleware {
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        // You can manipulate the request before calling the handler
        // and abort early if necessary, a good injection point for
        // handling auth.

        // return Response(status: .Forbidden, text: "Permission denied")

        var response = try chain.respond(to: request)

        response.headers["Access-Control-Allow-Origin"] = "*";
        response.headers["Access-Control-Allow-Headers"] = ["x-requested-with", "origin", "content-type", "accept"];
        response.headers["Access-Control-Allow-Methods"] = ["POST", "GET", "PUT", "OPTIONS", "DELETE", "PATCH"]

        return response

        // Vapor Middleware is based on S4 Middleware.
        // This means you can share it with any other project
        // that uses S4 Middleware.
	}
}
