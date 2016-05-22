//
//  MongoDaoBaseImpl.swift
//  VaporApp
//
//  Created by Sebastien Arbogast on 16/05/2016.
//
//

import Foundation
import MongoKitten

class MongoDaoBaseImpl {
    let username = "vaportodolistbackend"
    let password = "TtfJERaHjWLyX49P"
    let host = "ds011903.mlab.com"
    let port = "11903"
    let db = "vaportodolistbackend"
    
    let server:Server
    var database:Database {
        return server[db]
    }
    
    init() throws {
        try server = Server("mongodb://\(username):\(password)@\(host):\(port)", automatically: true)
    }
}