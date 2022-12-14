//
//  Organization.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent
import SwiftBSON
import Vapor

public final class Organization: Model, Content {
    public static let schema = "orgs"

    // MARK: Properties
    /// The timestamp when the organization was created using ISO8601.
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                             public var createdAt:          Date?
    @Field(key: "createdBy")                                                                public var createdBy:          User.IDValue
    /// The timestamp when the organization was deleted using ISO8601.
    @Timestamp(key: "deletedAt", on: .delete, format: .iso8601)                             public var deletedAt:          Date?
    @OptionalField(key: "domain")                                                           public var domain:             String?
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                     public var id:                 UUID?
    @Field(key: "name")                                                                     public var name:               String
    @OptionalField(key: "physicalAddress")                                                  public var physicalAddress:    String?
    /// The timestamp when the organization was updated using ISO8601.
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                             public var updatedAt:          Date?
    @Field(key: "username")                                                                 public var username:           String

    // MARK: Siblings
    @Siblings(through: PlateOrgPivot.self, from: \.$org, to: \.$plate)                      public var plates:             [Plate]
    @Siblings(through: UserOrganizationPivot.self, from: \.$org, to: \.$user)               public var users:              [User]

    // MARK: Children
    @Children(for: \.$organization)                                                         public var events:             [KeystoneEvent]
    @OptionalChild(for: \.$org)                                                             public var plan:               Plan?
    @Children(for: \.$org)                                                                  public var tables:             [TableSpace]

    public init() {}
    
    public init(_ name: String,
         username: String?,
         domain: String?,
         createdBy userID: User.IDValue)
    {
        self.name = name
        if let username = username {
            self.username = username
        } else if let hexString = SwiftBSON.BSON.init(arrayLiteral: .maxKey).objectIDValue?.hex {
            self.username = name + hexString
        } else {
            self.username = name + Int.random(in: 0...100000).description
        }
        self.domain = domain
        self.createdBy = userID
    }
    
    public convenience init(from data: ObjectData) throws {
        guard let createdBy = data.createdBy else {
            throw Abort(.badRequest)
        }
        self.init(data.name, username: data.username, domain: data.domain, createdBy: createdBy)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, on database: Database) async throws {
        if self.domain != data.domain {
            self.domain = data.domain
        }
        if self.name != data.name {
            self.name = data.name
        }
        if self.physicalAddress != data.physicalAddress {
            self.physicalAddress = data.physicalAddress
        }
        if let username = data.username, self.username != username {
            self.username = username
        }
        
        try await self.save(on: database)
    }
}

// MARK: CreationResponse
extension Organization {
    public func creationResponse() throws -> CreationResponse {
        return CreationResponse(id: try self.requireID())
    }
}

// MARK: ObjectData
extension Organization {
    public struct ObjectData: Content {
        public let createdAt:          Date?
        public let createdBy:          User.IDValue?
        public let domain:             String?
        public let id:                 Organization.IDValue?
        public let name:               String
        public let physicalAddress:    String?
        public let username:           String?
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, domain: self.domain, id: self.requireID(), name: self.name, physicalAddress: self.physicalAddress, username: self.username)
    }
}

extension Sequence where Element: Organization {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
