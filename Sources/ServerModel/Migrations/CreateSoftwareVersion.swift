//
//  CreateSoftwareVersion.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateSoftwareVersion: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Software.Version.schema)
            .id()
            .field("component", .string)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("depreciatedAt", .date)
            .field("info", .string, .required)
            .field("milestone", .string)
            .field("releasedAt", .date)
            .field("stage", .string, .required)
            .field("startedAt", .date)
            .field("name", .string, .required)
            .field("updatedAt", .date)
            .field("softwareID", .uuid, .required, .references(Software.schema, "id", onDelete: .cascade))
            .create()
    }

    public func revert(on database: Database) async throws {
        return try await database
            .schema(Software.Version.schema)
            .delete()
    }
    
    public init() {}
}
