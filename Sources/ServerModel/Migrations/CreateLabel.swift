//
//  CreateLabel.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

struct CreateLabel: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Label.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("title", .string, .required)
            .field("updatedAt", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Label.schema)
            .delete()
    }
}
