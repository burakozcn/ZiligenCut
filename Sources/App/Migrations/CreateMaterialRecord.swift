import Fluent

struct CreateMaterialRecord: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MaterialRecord")
      .field("id", .int, .required)
      .field("name", .string, .required)
      .field("color", .string)
      .field("issueDate", .string)
      .field("partyNumber", .string)
      .field("userID", .string, .required)
      .field("active", .bool)
      .field("width", .float, .required)
      .field("height", .float, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MaterialRecord").delete()
  }
}
