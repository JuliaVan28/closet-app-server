//
//  File.swift
//  
//
//  Created by Yuliia on 01/05/24.
//

import Foundation
import Fluent

struct CreateUsersTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required).unique(on: "username")
            .field("password", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("users")
            .delete()
    }
    
}
