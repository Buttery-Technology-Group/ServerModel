//
//  CreatePlateOrgPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/23/22.
//

import Fluent

struct CreatePlateOrgPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(PlateOrgPivot.schema)
            .id()
            .field("orgID", .uuid, .required, .references(Organization.schema, "id", onDelete: .cascade))
            .field("plateID", .uuid, .required, .references(Plate.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(PlateOrgPivot.schema)
            .delete()
    }
}
