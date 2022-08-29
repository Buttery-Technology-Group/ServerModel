//
//  CreateSettings.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent

public struct CreateSettings: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Settings.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("general", .array(of: .custom(Setting.self)))
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .field("projectID", .uuid, .references(Project.schema, "id", onDelete: .cascade))
            .field("softwareID", .uuid, .references(Software.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Settings.schema)
            .delete()
    }
    
    public init() {}
}
