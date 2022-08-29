//
//  CreateProjectAction.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateProjectAction: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Project.Action.schema)
            .id()
            .field("allowMultipleSelection", .bool, .required)
            .field("approved", .bool, .required)
            .field("associatedPrice", .string)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("explanation", .string, .required)
            .field("options", .array(of: .custom(Project.Action.Option.self)), .required)
            .field("projectID", .uuid, .required, .references(Project.schema, "id", onDelete: .cascade))
            .field("selections", .array(of: .custom(Project.Action.Option.self)), .required)
            .field("title", .string, .required)
            .field("updatedAt", .string)
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Project.Action.schema)
            .delete()
    }
}
