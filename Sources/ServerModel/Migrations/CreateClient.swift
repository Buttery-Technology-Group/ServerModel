//
//  CreateClient.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/13/22.
//

import Fluent

struct CreateClient: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Client.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("deletedAt", .string)
            .field("email", .string, .required)
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Client.schema)
            .delete()
    }
}
