//
//  CreateClientToken.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/13/22.
//

import Fluent

public struct CreateClientToken: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(Client.Token.schema)
            .id()
            .field("date", .string, .required)
            .field("expiresAt", .uuid)
            .field("value", .string, .required)
            .field("clientID", .uuid, .required, .references(Client.schema, "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(Client.Token.schema)
            .delete()
    }
    
    public init() {}
}
