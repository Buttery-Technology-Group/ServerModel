//
//  CreateProject.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Project.schema)
            .id()
            .field("butteryProfile", .custom(Project.ButteryProfile.self), .required)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("generalAccess", .string, .required)
            .field("logo", .data)
            .field("name", .string, .required)
            .field("status", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Project.schema)
            .delete()
    }
}
