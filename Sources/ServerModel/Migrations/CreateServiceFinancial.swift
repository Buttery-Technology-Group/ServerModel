//
//  CreateServiceFinancial.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateServiceFinancial: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Service.Financial.schema)
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
            .field("serviceID", .uuid, .required, .references(Service.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Service.Financial.schema)
            .delete()
    }
}
