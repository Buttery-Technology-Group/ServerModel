//
//  CreatePlateItem.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/22/22.
//

import Fluent
import Vapor

struct CreatePlateItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Plate.Item.schema)
            .id()
            .field("assignee", .uuid)
            .field("completed", .bool, .required)
            .field("completedOn", .date)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("dueDate", .date)
            .field("info", .string, .required)
            .field("plateID", .uuid, .required, .references(Plate.schema, "id", onDelete: .cascade))
            .field("stage", .string, .required)
            .field("startDate", .date)
            .field("title", .string, .required)
            .field("updatedAt", .date)
            .field("projectID", .uuid)
            .field("serviceID", .uuid)
            .field("softwareID", .uuid)
            .field("ownerID", .uuid)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Plate.Item.schema)
            .delete()
    }
}
