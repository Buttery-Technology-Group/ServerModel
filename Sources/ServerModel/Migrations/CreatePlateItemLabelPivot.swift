//
//  CreatePlateItemLabelPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/22/22.
//

import Fluent

public struct CreatePlateItemLabelPivot: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(PlateItemLabelPivot.schema)
            .id()
            .field("labelID", .uuid, .required, .references(Label.schema, "id", onDelete: .cascade))
            .field("plateItemID", .uuid, .required, .references(Plate.Item.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(PlateItemLabelPivot.schema)
            .delete()
    }
}
