import Fluent

extension Entity {
    static func deleteAll() throws {
        try Self.query().delete()
    }

    func update() throws {
        let T = type(of: self)
        guard let database = T.database else { return }

        let data = try makeNode()
        let query = try T.query()

        query.action = .modify
        query.data = data
        
        let idKey = database.driver.idKey
        data[idKey].flatMap { id in
            let entity = T.self
            let idFilter = Filter(entity, .compare(idKey, .equals, id))
            query.filters.append(idFilter)
        }

        try query.run()
    }
}
