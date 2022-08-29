//
//  Address.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/5/22.
//

import Fluent
import Foundation
import Vapor

public final class Address: Model, Content {
    public static let schema = "addresses"

    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:          Date?
    /// The unique identifier for the email address. Created automatically by the database.
    @ID(key: .id)                                                   public var id:                 UUID?
    @Field(key: "isPrimary")                                        public var isPrimary:          Bool
    @Field(key: "street")                                           public var street:             String
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:          Date?
    @Field(key: "zipCode")                                          public var zipCode:            String

    // MARK: Parent
    @Parent(key: "userID")                                          public var user:               User

    // MARK: Initializers
    public init() {}
    
    public init(_ street: String,
         zipCode: String,
         isPrimary: Bool,
         userID: User.IDValue)
    {
        self.street = street
        self.zipCode = zipCode
        self.isPrimary = isPrimary
        self.$user.id = userID
    }
    
    convenience public init(data: ObjectData) {
        self.init(data.street, zipCode: data.zipCode, isPrimary: data.isPrimary, userID: data.userID!)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, on database: Database) async throws {
        if self.isPrimary != data.isPrimary {
            self.street = data.street
        }
        if self.street != data.street {
            self.street = data.street
        }
        if self.zipCode != data.zipCode {
            self.zipCode = data.zipCode
        }
        
        try await self.save(on: database)
    }
}

extension Address {
    public func created() throws -> CreationResponse {
        return CreationResponse(id: try self.requireID())
    }
    
    public struct ObjectData: Content {
        public let createdAt:      Date?
        public let id:             Address.IDValue?
        public let isPrimary:      Bool
        public let street:         String
        public let updatedAt:      Date?
        public let userID:         User.IDValue?
        public let zipCode:        String
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, id: try self.requireID(), isPrimary: self.isPrimary, street: self.street, updatedAt: self.updatedAt, userID: self.user.requireID(), zipCode: self.zipCode)
    }
}

extension Sequence where Element: Address {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
