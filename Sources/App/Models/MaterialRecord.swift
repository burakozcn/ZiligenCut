import Fluent
import Vapor

final class MaterialRecord: Model, Content {
  static let schema = "MaterialRecord"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "name")
  var name: String
  
  @Field(key: "color")
  var color: String
  
  @Field(key: "issueDate")
  var issueDate: String
  
  @Field(key: "partyNumber")
  var partyNumber: String
  
  @Field(key: "userID")
  var userID: Int
  
  @Field(key: "active")
  var active: Bool
  
  @Field(key: "width")
  var width: Float
  
  @Field(key: "height")
  var height: Float
  
  init() { }
  
  init(id: Int? = nil, name: String, color: String, issueDate: String, partyNumber: String, userID: Int, active: Bool, width: Float, height: Float) {
    self.id = id
    self.name = name
    self.color = color
    self.issueDate = issueDate
    self.partyNumber = partyNumber
    self.userID = userID
    self.active = active
    self.width = width
    self.height = height
  }
}
