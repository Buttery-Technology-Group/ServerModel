//
//  CreatePlateUserPivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/23/22.
//

import Fluent

public struct CreatePlateUserPivot: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(PlateUserPivot.schema)
            .id()
            .field("plateID", .uuid, .required, .references(Plate.schema, "id", onDelete: .cascade))
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(PlateUserPivot.schema)
            .delete()
    }
    
    public init() {}
}
