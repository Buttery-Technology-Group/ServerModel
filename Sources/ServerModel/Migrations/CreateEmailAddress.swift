//
//  CreateEmailAddress.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/6/22.
//

import Fluent

public struct CreateEmailAddress: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(EmailAddress.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("isPrimary", .string, .required)
            .field("isVerified", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("value", .string, .required)
            .unique(on: "value")
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(EmailAddress.schema)
            .delete()
    }
    
    public init() {}
}
