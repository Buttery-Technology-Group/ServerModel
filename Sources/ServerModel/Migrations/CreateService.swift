//
//  CreateService.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateService: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Service.schema)
            .id()
            .field("completed", .bool, .required)
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("endDate", .date)
            .field("info", .string)
            .field("name", .string, .required)
            .field("percentagePaid", .int, .required)
            .field("startDate", .date)
            .field("stripeID", .string)
            .field("updatedAt", .string)
            .field("projectID", .uuid, .required, .references(Project.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Service.schema)
            .delete()
    }
    
    public init() {}
}
