import Fluent

struct CreateMaterialRecord: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("User")
      .field("id", .int, .required)
      .field("name", .string, .required)
      .field("surname", .string, .required)
      .field("mail", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("User").delete()
  }
}
