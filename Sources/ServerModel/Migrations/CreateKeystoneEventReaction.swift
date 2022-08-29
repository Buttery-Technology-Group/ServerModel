//
//  CreateKeystoneEventReaction.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent

struct CreateKeystoneEventReaction: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.Reaction.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("type", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.Reaction.schema)
            .delete()
    }
}
