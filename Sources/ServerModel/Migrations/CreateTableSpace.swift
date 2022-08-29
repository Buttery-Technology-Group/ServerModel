//
//  CreateTableSpace.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/27/22.
//

import Fluent
import Vapor

struct CreateTableSpace: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(TableSpace.schema)
            .id()
            .field("assignee", .uuid)
            .field("completed", .bool, .required)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("dueDate", .date)
            .field("finishedOn", .date)
            .field("info", .string)
            .field("manager", .uuid)
            .field("maxCount", .int, .required)
            .field("name", .string, .required)
            .field("orgID", .uuid, .references(Organization.schema, "id", onDelete: .cascade))
            .field("ownerID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("reviewer", .uuid)
            .field("startedOn", .date)
            .field("updatedAt", .date)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(TableSpace.schema)
            .delete()
    }
}
