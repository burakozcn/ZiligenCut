import Fluent
import Vapor

final class MapRecord: Content, Model {
  static let schema = "MapRecord"
  
  @Field(key: "id")
  var id: Int?
  
  @Field(key: "partyNumber")
  var partyNumber: String
  
  @Field(key: "mapLetter")
  var mapLetter: String
  
  @Field(key: "description")
  var description: String
  
  @Field(key: "issueDate")
  var issueDate: Date
  
  @Field(key: "userID")
  var userID: Int
  
  @Field(key: "aValue")
  var aValue: Double
  
  @Field(key: "bValue")
  var bValue: Double
  
  init() {
  }
  
  init(id: Int? = nil, partyNumber: String, mapLetter: String, description: String, issueDate: Date, userID: Int) {
    self.id = id
    self.partyNumber = partyNumber
    self.mapLetter = mapLetter
    self.description = description
    self.issueDate = issueDate
    self.userID = userID
  }
}
