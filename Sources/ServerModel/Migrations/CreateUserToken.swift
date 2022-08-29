//
//  CreateUserToken.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent

struct CreateUserToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(User.Token.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("expiresAt", .date)
            .field("value", .string, .required)
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(User.Token.schema)
            .delete()
    }
}
