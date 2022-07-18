import Fluent
import Vapor

final class Token: Model, Content {
  static let schema = "tokens"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "value")
  var value: String
  
  @Parent(key: "user_id")
  var user: User
  
  init() { }
  
  init(id: Int? = nil, value: String, userID: User.IDValue) {
    self.id = id
    self.value = value
    self.user.id = userID
  }
}

extension Token: ModelTokenAuthenticatable {
  static let valueKey = \Token.$value
  static let userKey = \Token.$user
  
  var isValid: Bool { true }
}
