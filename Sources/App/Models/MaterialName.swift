import Fluent
import Vapor

final class MaterialName: Content, Model {
  static let schema = "MaterialName"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "code")
  var code: String
  
  @Field(key: "material")
  var material: String
  
  init() { }
  
  init(id: Int? = nil, code: String, material: String) {
    self.id = id
    self.code = code
    self.material = material
  }
}

