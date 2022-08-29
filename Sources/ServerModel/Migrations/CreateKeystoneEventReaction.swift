//
//  CreateKeystoneEventReaction.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent

public struct CreateKeystoneEventReaction: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.Reaction.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("type", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.Reaction.schema)
            .delete()
    }
}
