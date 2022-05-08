import Fluent

struct CreateMapRecord: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MapRecord")
      .field("id", .int, .required)
      .field("partyNumber", .string, .required)
      .field("mapLetter", .string, .required)
      .field("description", .string)
      .field("issueDate", .date)
      .field("userID", .string, .required)
      .field("aValue", .double, .required)
      .field("bValue", .double, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("MaterialRecord").delete()
  }
}

