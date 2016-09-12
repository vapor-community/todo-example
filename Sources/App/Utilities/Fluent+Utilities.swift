import Fluent

extension Entity {
    static func deleteAll() throws {
        try Self.query().delete()
    }
}
