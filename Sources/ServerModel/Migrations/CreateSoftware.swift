//
//  CreateSoftware.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateSoftware: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Software.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("generalAccess", .string, .required)
            .field("info", .string)
            .field("name", .string, .required)
            .field("platforms", .array(of: .string), .required)
            .field("releasedAt", .date)
            .field("startedAt", .date)
            .field("stage", .string, .required)
            .field("updatedAt", .string)
            .field("useCustomLifeCycle", .bool, .required)
            .field("projectID", .uuid, .required, .references(Project.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Software.schema)
            .delete()
    }
    
    public init() {}
}
