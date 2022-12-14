//
//  CreateSoftwareCustomLifeCycle.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateSoftwareCustomLifeCycle: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Software.CustomLifeCycle.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("info", .string)
            .field("name", .string, .required)
            .field("position", .int, .required)
            .field("updatedAt", .string)
            .field("softwareID", .uuid, .required, .references(Software.schema, "id", onDelete: .cascade))
            .create()
    }

    public func revert(on database: Database) async throws {
        return try await database
            .schema(Software.CustomLifeCycle.schema)
            .delete()
    }
    
    public init() {}
}
