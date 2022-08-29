//
//  CreateSoftwareReleaseSchedule.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

struct CreateSoftwareReleaseSchedule: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Software.ReleaseSchedule.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("info", .string)
            .field("milestone", .string)
            .field("plan", .array(of: .custom(Software.ReleaseSchedule.Plan.self)), .required)
            .field("stage", .string, .required)
            .field("targetDate", .date)
            .field("title", .string)
            .field("updatedAt", .date)
            .field("softwareID", .uuid, .required, .references(Software.ReleaseSchedule.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database
            .schema(Software.ReleaseSchedule.schema)
            .delete()
    }
}
