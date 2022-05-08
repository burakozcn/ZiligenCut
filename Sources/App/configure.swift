import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) throws {
  // uncomment to serve files from /Public folder
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
  app.databases.use(.mysql(
    hostname: Environment.get("localhost") ?? "localhost",
    port: Environment.get("3306").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
    username: Environment.get("root") ?? "root",
    password: Environment.get("Nomh1988!") ?? "Nomh1988!",
    database: Environment.get("ZiligenCut") ?? "ZiligenCut",
    tlsConfiguration: .forClient(certificateVerification: .none)),
    as: .mysql)
  
  app.migrations.add(CreateCutRecord())
  app.migrations.add(CreateMapRecord())
  app.migrations.add(CreateMaterialRecord())
  app.migrations.add(CreateMaterialName())
  
  try app.autoMigrate().wait()
  // register routes
  try routes(app)
}
