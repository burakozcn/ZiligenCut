import Fluent

struct CreateUser: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("User")
      .field("id", .int, .required)
      .field("name", .string, .required)
      .field("surname", .string, .required)
      .field("mail", .string, .required)
      .field("password_hash", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("User").delete()
  }
}
