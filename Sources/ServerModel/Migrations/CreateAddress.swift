//
//  CreateAddress.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/6/22.
//

import Fluent

struct CreateAddress: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Address.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("deletedAt", .string)
            .field("isPrimary", .string, .required)
            .field("street", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("zipCode", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Address.schema)
            .delete()
    }
}
