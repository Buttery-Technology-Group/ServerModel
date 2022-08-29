//
//  CreatePlate.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/23/22.
//

import Fluent
import Vapor

struct CreatePlate: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Plate.schema)
            .id()
            .field("assignee", .uuid)
            .field("completed", .bool, .required)
            .field("component", .uuid)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("dueDate", .date)
            .field("finishedOn", .date)
            .field("info", .string)
            .field("manager", .uuid)
            .field("maxCount", .int, .required)
            .field("ownerID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("reporter", .uuid)
            .field("reviewer", .uuid)
            .field("startedOn", .date)
            .field("tableID", .uuid, .required, .references(TableSpace.schema, "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("updatedAt", .date)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Plate.schema)
            .delete()
    }
}
