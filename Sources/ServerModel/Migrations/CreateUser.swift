//
//  CreateUser.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 6/26/22.
//

import Fluent

public struct CreateUser: AsyncMigration {
    public func prepare(on database: Database) async throws {
        return try await database
            .schema(User.schema)
            .id()
            .field("createdAt", .string, .required)
            .field("createdBy", .uuid)
            .field("defaultEmail", .string, .required)
            .field("deletedAt", .string)
            .field("lastLogin", .date)
            .field("isOnline", .bool, .required)
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("physicalAddress", .string)
            .field("siwaIdentifier", .string)
            .field("updatedAt", .string)
            .field("username", .string, .required)
            .unique(on: "username")
            .create()
    }
    
    public func revert(on database: Database) async throws {
        return try await database
            .schema(User.schema)
            .delete()
    }
    
    public init() {}
}
