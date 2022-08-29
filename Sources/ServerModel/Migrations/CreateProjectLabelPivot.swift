//
//  CreateProjectLabelPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

struct CreateProjectLabelPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(ProjectLabelPivot.schema)
            .id()
            .field("labelID", .uuid, .references(Label.schema, "id", onDelete: .cascade))
            .field("projectID", .uuid, .references(Project.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database
            .schema(ProjectLabelPivot.schema)
            .delete()
    }
}
