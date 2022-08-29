//
//  CreateProjectLabelPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/25/22.
//

import Fluent

public struct CreateProjectLabelPivot: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(ProjectLabelPivot.schema)
            .id()
            .field("labelID", .uuid, .references(Label.schema, "id", onDelete: .cascade))
            .field("projectID", .uuid, .references(Project.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(ProjectLabelPivot.schema)
            .delete()
    }
    
    public init() {}
}
