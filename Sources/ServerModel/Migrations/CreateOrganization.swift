//
//  CreateOrganization.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent

struct CreateOrganization: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Organization.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid, .required)
            .field("deletedAt", .string)
            .field("domain", .string)
            .field("name", .string, .required)
            .field("physicalAddress", .string)
            .field("updatedAt", .string)
            .field("username", .string, .required)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(Organization.schema)
            .delete()
    }
}
