import Fluent
import Vapor
import MySQLKit

struct Controller: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let mat = routes.grouped("material")
    mat.get(use: indexMaterial)
    mat.post(use: createMaterial)
    mat.get("indexNames", use: indexNames)
    mat.get("indexMat", ":partyNumber", use: getMaterial)
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
}
