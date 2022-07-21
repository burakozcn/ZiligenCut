import Fluent
import Vapor

final class CutRecord: Content, Model {
  static let schema = "CutRecord"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "partyNumber")
  var partyNumber: String
  
  @Field(key: "cutNumber")
  var cutNumber: String
  
  @Field(key: "xStart")
  var xStart: Float
  
  @Field(key: "xEnd")
  var xEnd: Float
  
  @Field(key: "yStart")
  var yStart: Float
  
  @Field(key: "yEnd")
  var yEnd: Float
  
  @Field(key: "left")
  var left: Bool
  
  @Field(key: "up")
  var up: Bool
  
  @Field(key: "horizontal")
  var horizontal: Bool
  
  @Field(key: "vertical")
  var vertical: Bool
  
  @Field(key: "userID")
  var userID: Int
  
  init() {
  }
  
  init(id: Int? = nil, partyNumber: String, cutNumber: String, xStart: Float, xEnd: Float, yStart: Float, yEnd: Float, left: Bool, up: Bool, horizontal: Bool, vertical: Bool, userID: Int) {
    self.id = id
    self.partyNumber = partyNumber
    self.cutNumber = cutNumber
    self.xStart = xStart
    self.xEnd = xEnd
    self.yStart = yStart
    self.yEnd = yEnd
    self.left = left
    self.horizontal = horizontal
    self.vertical = vertical
    self.userID = userID
  }
}
