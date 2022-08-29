//
//  CreateKeystoneEvent.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent

public struct CreateKeystoneEvent: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("date", .date)
            .field("deletedAt", .string)
            .field("info", .string)
            .field("financialID", .uuid, .references(Service.Financial.schema, "id", onDelete: .cascade))
            .field("organizationID", .uuid, .references(Organization.schema, "id", onDelete: .cascade))
            .field("projectID", .uuid, .references(Project.schema, "id", onDelete: .cascade))
            .field("releaseScheduleID", .uuid, .references(Software.ReleaseSchedule.schema, "id", onDelete: .cascade))
            .field("serviceID", .uuid, .references(Service.schema, "id", onDelete: .cascade))
            .field("softwareID", .uuid, .references(Software.schema, "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("type", .string, .required)
            .field("updatedAt", .string)
            .field("userID", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .field("versionID", .uuid, .references(Software.Version.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(KeystoneEvent.schema)
            .delete()
    }
    
    public init() {}
}
