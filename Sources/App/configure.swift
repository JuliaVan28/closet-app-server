import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    
    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password: "", database: "closetdb"), as: .psql)
    
    //register migrations
    app.migrations.add(CreateUsersTableMigration())
    
    //register controllers
    try app.register(collection: UserController())
    
    app.jwt.signers.use(.hs256(key: "HSKEITOQPPL"))
    
    try routes(app)
}
