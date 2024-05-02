//
//  File.swift
//  
//
//  Created by Yuliia on 02/05/24.
//

import Foundation
import Vapor
import Fluent

class UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        // api/register
        api.post("register", use: register)
        
        // api/login
        api.post("login", use: login)
    }
    
    func login(req: Request) async throws -> LoginResponseDTO {
        // decode request
        
        let user = try req.content.decode(User.self)
        
        //check if user exists in db
        
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
            throw Abort(.badRequest)
        }
        
        //validating password
        let result = try await req.password.async.verify(user.password, created: existingUser.password)
        
        if !result { throw Abort(.unauthorized)}
        
        //generating token and assigning it to user
        let authPayload = try AuthPayload(subject: .init(value: "Closet App"), expiration: .init(value: .distantFuture), userID: existingUser.requireID())
        return try LoginResponseDTO(error: false, token: req.jwt.sign(authPayload), userId: existingUser.requireID())
        
    }
    
    func register(req: Request) async throws -> RegisterResponseDTO {
        //validate user
        try User.validate(content: req)
        
        let user = try req.content.decode(User.self)
        
        //if the user already exists with this username
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() {
            throw Abort(.conflict, reason: "Username is already taken")
        }
        
        // hash the password
        user.password = try await req.password.async.hash(user.password)
        
        //save user to db
        try await user.save(on: req.db)
        
        return RegisterResponseDTO(error: false)
    }
    
}
