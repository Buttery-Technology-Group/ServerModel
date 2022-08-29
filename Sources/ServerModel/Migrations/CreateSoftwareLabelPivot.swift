//
//  CreateSoftwareLabelPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

struct CreateSoftwareLabelPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(SoftwareLabelPivot.schema)
            .id()
            .field("labelID", .uuid, .references(Label.schema, "id", onDelete: .cascade))
            .field("softwareID", .uuid, .references(Software.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(SoftwareLabelPivot.schema)
            .delete()
    }
}
