import Fluent
import Vapor

final class User: Content, Model {
  static let schema = "user"
  
  @ID(custom: "id")
  var id: Int?
  
  @Field(key: "name")
  var name: String
  
  @Field(key: "surname")
  var surname: String
  
  @Field(key: "mail")
  var mail: String
  
  @Field(key: "password_hash")
  var passwordHash: String
  
  func generateToken() throws -> Token {
    try .init(value: [UInt8].random(count: 16).base64, userID: self.requireID())
  }
  
  init() { }
  
  init(id: Int? = nil, name: String, surname: String, mail: String, passwordHash: String) {
    self.id = id
    self.name = name
    self.surname = surname
    self.mail = mail
    self.passwordHash = passwordHash
  }
}

extension User: ModelAuthenticatable {
  static let usernameKey = \User.$mail
  static let passwordHashKey = \User.$passwordHash
  
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.passwordHash)
  }
}

extension User {
  struct Create: Content {
    var name: String
    var surname: String
    var mail: String
    var password: String
    var confirmPassword: String
  }
}

extension User.Create: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("name", as: String.self, is: .count(3...) && .alphanumeric)
    validations.add("mail", as: String.self, is: .email)
    validations.add("password", as: String.self, is: .count(8...))
  }
}

extension User: ModelSessionAuthenticatable { }

extension User: SessionAuthenticatable {
  typealias SessionID = Int
  
  var sessionID: SessionID { self.id! }
}

struct UserModelSessionAuthenticator: SessionAuthenticator {
  typealias User = App.User
  
  func authenticate(sessionID: User.SessionID, for req: Request) -> EventLoopFuture<Void> {
    User.find(sessionID, on: req.db).map { user  in
      if let user = user {
        req.auth.login(user)
      }
    }
  }
}

struct UserModelCredentialsAuthenticator: CredentialsAuthenticator {
  
  struct Input: Content {
    let mail: String
    let password: String
  }
  
  typealias Credentials = Input
  
  func authenticate(credentials: Credentials, for req: Request) -> EventLoopFuture<Void> {
    User.query(on: req.db)
      .filter(\.$mail == credentials.mail)
      .first()
      .map {
        do {
          if let user = $0, try Bcrypt.verify(credentials.password, created: user.passwordHash) {
            req.auth.login(user)
          }
        }
        catch {
          // do nothing...
        }
      }
  }
}
