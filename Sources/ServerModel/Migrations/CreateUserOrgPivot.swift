//
//  CreateUserOrgPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/24/22.
//

import Fluent

struct CreateUserOrgPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(UserOrganizationPivot.schema)
            .id()
            .field("systemAccess", .int, .required)
            .field("orgID", .uuid, .required, .references(Organization.schema, "id", onDelete: .cascade))
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(UserOrganizationPivot.schema)
            .delete()
    }
}
