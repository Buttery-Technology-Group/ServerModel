//
//  CreatePlan.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent

public struct CreatePlan: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Plan.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("info", .string)
            .field("name", .string, .required)
            .field("orgID", .uuid, .references(Organization.schema, "id", onDelete: .cascade))
            .field("percentagePaid", .int, .required)
            .field("startDate", .date)
            .field("stripeID", .string)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Plan.schema)
            .delete()
    }
    
    public init() {}
}
