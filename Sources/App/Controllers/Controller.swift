import Fluent
import Vapor
import MySQLKit

struct Controller: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let home = routes.grouped("")
    home.get(use: homeHandler)
    
    let user = routes.grouped("user")
    user.post(use: createUser)
    
    let passProtected = routes.grouped(User.guardMiddleware())
    passProtected.post("token", use: getToken)
    
    let tokenProtected = routes.grouped(Token.guardMiddleware())
    tokenProtected.get("getUser", use: getUser)
    
    let credentialsProtectedRoute = routes.grouped([User.sessionAuthenticator(.mysql), UserModelCredentialsAuthenticator(), User.redirectMiddleware(path: "loginNeeded")])
    credentialsProtectedRoute.post("login", use: loginPostHandler)
    credentialsProtectedRoute.get("logout", use: logoutHandler)
    
    let check = credentialsProtectedRoute.grouped("check")
    check.get(use: checkHandler)
    
    let mat = credentialsProtectedRoute.grouped("material")
    mat.get(use: indexMaterial)
    mat.post(use: createMaterial)
    mat.get("indexNames", use: indexNames)
    mat.get("name", ":partyNumber", use: getMaterialName)
    mat.get("indexMat", ":partyNumber", use: getMaterial)
    mat.post("cut", use: createCut)
    mat.get("indexCut", ":partyNumber", use: getCut)
    
    let version = credentialsProtectedRoute.grouped("version")
    version.get(use: getVersion)
  }
  
  func homeHandler(req: Request) -> String {
    return "Kiremit is under construction!"
  }
  
  func checkHandler(req: Request) -> String {
    return "There is an active login. Welcome back!"
  }
  
  func indexMaterial(req: Request) throws -> EventLoopFuture<[MaterialRecord]> {
    return MaterialRecord.query(on: req.db).all()
  }
  
  func createMaterial(req: Request) throws -> EventLoopFuture<MaterialRecord> {
    let material = try req.content.decode(MaterialRecord.self)
    return material.save(on: req.db).map { material }
  }
  
  func indexNames(req: Request) throws -> EventLoopFuture<[MaterialName]> {
    return MaterialName.query(on: req.db).all()
  }
  
  func getMaterial(req: Request) throws -> EventLoopFuture<[MaterialRecord]> {
    guard let partyNum = req.parameters.get("partyNumber") else {
      throw Abort(.notFound)
    }
    return (req.db as! SQLDatabase).raw("""
    SELECT * from ZiligenCut.MaterialRecord
    where partyNumber = '\(raw: partyNum)'
    """).all(decoding: MaterialRecord.self)
  }
  
  func getMaterialName(req: Request) throws -> EventLoopFuture<[MaterialRecord]> {
    guard let partyNum = req.parameters.get("partyNumber") else {
      throw Abort(.notFound)
    }
    return (req.db as! SQLDatabase).raw("""
    SELECT name from ZiligenCut.MaterialRecord
    where partyNumber = '\(raw: partyNum)'
    """).all(decoding: MaterialRecord.self)
  }
  
  func createCut(req: Request) throws -> EventLoopFuture<CutRecord> {
    let cutRecord = try req.content.decode(CutRecord.self)
    return cutRecord.save(on: req.db).map { cutRecord }
  }
  
  func getCut(req: Request) throws -> EventLoopFuture<[CutRecord]> {
    guard let partyNum = req.parameters.get("partyNumber") else {
      throw Abort(.notFound)
    }
    return (req.db as! SQLDatabase).raw("""
    SELECT * from ZiligenCut.CutRecord
    where partyNumber = '\(raw: partyNum)'
    """).all(decoding: CutRecord.self)
  }
  
  func createUser(req: Request) throws -> EventLoopFuture<User> {
    try User.Create.validate(content: req)
    
    let create = try req.content.decode(User.Create.self)
    guard create.password == create.confirmPassword else {
      throw Abort(.badRequest, reason: "Passwords did not match")
    }
    
    let user = try User(name: create.name, surname: create.surname, mail: create.mail, passwordHash: Bcrypt.hash(create.password))
    
    return user.save(on: req.db).map { user }
  }
  
  func getToken(req: Request) throws -> EventLoopFuture<Token> {
    let user = try req.auth.require(User.self)
    let token = try user.generateToken()
    return token.save(on: req.db)
      .map { token }
  }
  
  func getUser(req: Request) throws -> User {
    try req.auth.require(User.self)
  }
  
  func loginPostHandler(req: Request) throws -> Response {
    guard let user = req.auth.get(User.self) else {
      throw Abort(.unauthorized)
    }
    req.session.authenticate(user)
    return req.redirect(to: "/")
  }
  
  func logoutHandler(req: Request) throws -> Response {
    req.auth.logout(User.self)
    req.session.unauthenticate(User.self)
    return req.redirect(to: "/")
  }
  
  func getVersion(req: Request) throws -> EventLoopFuture<[VersionList]> {
    return (req.db as! SQLDatabase).raw("""
      SELECT * FROM ZiligenCut.VersionList
    """).all(decoding: VersionList.self)
  }
}
