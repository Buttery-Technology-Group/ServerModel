//
//  CreateUserTablePivot.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/27/22.
//

import Fluent

public struct CreateUserTablePivot: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(UserTablePivot.schema)
            .id()
            .field("tableID", .uuid, .required, .references(TableSpace.schema, "id", onDelete: .cascade))
            .field("userID", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .unique(on: "userID", "tableID")
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(UserTablePivot.schema)
            .delete()
    }
    
    public init() {}
}
