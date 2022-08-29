//
//  CreateUserOrgPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/24/22.
//

import Fluent

public struct CreateUserOrgPivot: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(UserOrganizationPivot.schema)
            .id()
            .field("systemAccess", .int, .required)
            .field("orgID", .uuid, .required, .references(Organization.schema, "id", onDelete: .cascade))
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(UserOrganizationPivot.schema)
            .delete()
    }
    
    public init() {}
}
