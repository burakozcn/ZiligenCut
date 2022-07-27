import Fluent
import Vapor

final class VersionList: Content, Model {
  static let schema = "VersionList"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "versionName")
  var versionName: String
  
  @Field(key: "date")
  var date: Date
  
  init() { }
  
  init(id: Int? = nil, versionName: String, date: Date) {
    self.id = id
    self.versionName = versionName
    self.date = date
  }
}
