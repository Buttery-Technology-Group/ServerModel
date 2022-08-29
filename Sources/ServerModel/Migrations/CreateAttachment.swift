//
//  CreateAttachment.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/22/22.
//

import Fluent

public struct CreateAttachment: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Attachment.schema)
            .id()
            .field("associatedValue", .string)
            .field("createdAt", .string, .required)
            .field("data", .data)
            .field("type", .string, .required)
            .field("updatedAt", .string)
            .field("plateItemID", .uuid, .references(Plate.Item.schema, "id", onDelete: .cascade))
            .field("projectID", .uuid, .references(Project.schema, "id", onDelete: .cascade))
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Attachment.schema)
            .delete()
    }
    
    public init() {}
}
