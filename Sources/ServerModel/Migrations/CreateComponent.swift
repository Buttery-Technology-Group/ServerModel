//
//  CreateComponent.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/27/22.
//

import Fluent

struct CreateComponent: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Component.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .string, .required)
            .field("generalAccess", .int, .required)
            .field("info", .string)
            .field("name", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id"))
            .field("orgID", .uuid, .references(Organization.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Component.schema)
            .delete()
    }
}
