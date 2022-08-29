//
//  CreatePlanFinancial.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent

public struct CreatePlanFinancial: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Plan.Financial.schema)
            .id()
            .field("collected", .bool, .required)
            .field("createdAt", .string, .required)
            .field("discount", .string, .required)
            .field("info", .string)
            .field("percentagePaid", .int, .required)
            .field("stripeID", .string)
            .field("subtotal", .string, .required)
            .field("tax", .string, .required)
            .field("title", .string, .required)
            .field("total", .string, .required)
            .field("updatedAt", .string)
            .field("planID", .uuid, .required, .references(Plan.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Plan.Financial.schema)
            .delete()
    }
}
