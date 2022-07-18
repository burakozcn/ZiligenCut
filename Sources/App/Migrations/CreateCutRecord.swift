import Fluent

struct CreateCutRecord: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("CutRecord")
      .field("id", .int, .required)
      .field("partyNumber", .string, .required)
      .field("cutNumber", .string, .required)
      .field("xStart", .float, .required)
      .field("xEnd", .float, .required)
      .field("yStart", .float, .required)
      .field("yEnd", .float, .required)
      .field("left", .bool, .required)
      .field("up", .bool, .required)
      .field("horizontal", .bool, .required)
      .field("vertical", .bool, .required)
      .field("userID", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("CutRecord").delete()
  }
}
