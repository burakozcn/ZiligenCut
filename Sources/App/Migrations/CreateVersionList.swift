import Fluent

struct CreateVersionList: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("VersionList")
      .field("id", .int, .required)
      .field("versionName", .string, .required)
      .field("date", .date, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("VersionList").delete()
  }
}
