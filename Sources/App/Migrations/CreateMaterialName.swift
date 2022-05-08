import Fluent

struct CreateMaterialName: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MaterialName")
      .id()
      .field("code", .string, .required)
      .field("material", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MaterialName")
      .delete()
  }
}
