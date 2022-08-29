//
//  Component.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/24/22.
//

import Fluent
import Vapor

public final class Component: Model, Content {
    public static let schema = "components"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:          Date?
    @Field(key: "createdBy")                                        public var createdBy:          User.IDValue
    @Field(key: "generalAccess")                                    public var generalAccess:      GeneralAccess
    /// The unique identifier for the email address. Created automatically by the database.
    @ID                                                             public var id:                 UUID?
    @OptionalField(key: "info")                                     public var info:               String?
    @Field(key: "name")                                             public var name:               String
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:          Date?
    
    // MARK: Parent
    @OptionalParent(key: "userID")                                  public var user:               User?
    @OptionalParent(key: "orgID")                                   public var org:                Organization?
    
    // MARK: Initializers
    public init() {}
    
    public init(name: String, info: String?, generalAccess: GeneralAccess, createdBy: User.IDValue, userID: User.IDValue?, orgID: Organization.IDValue?) {
        self.name = name
        self.info = info
        self.generalAccess = generalAccess
        self.createdBy = createdBy
        if let userID = userID {
            self.$user.id = userID
        }
        if let orgID = orgID {
            self.$org.id = orgID
        }
    }
    
    convenience public init(data: ObjectData) {
        self.init(name: data.name, info: data.info, generalAccess: data.generalAccess, createdBy: data.createdBy, userID: data.user, orgID: data.org)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, using database: Database) async throws {
        if self.generalAccess != data.generalAccess {
            self.generalAccess = data.generalAccess
        }
        if self.info != data.info {
            self.info = data.info
        }
        if self.name != data.name {
            self.name = data.name
        }
        if self.$org.id != data.org {
            self.$org.id = data.org
        }
        if self.$user.id != data.user {
            self.$user.id = data.user
        }
        
        try await self.save(on: database)
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, generalAccess: self.generalAccess, id: self.requireID(), info: self.info, name: self.name, org: self.$org.id, updatedAt: self.updatedAt, user: self.$user.id)
    }
}

extension Component {
    public struct ObjectData: Content {
        public let createdAt:              Date?
        public let createdBy:              User.IDValue
        public let generalAccess:          GeneralAccess
        public let id:                     Component.IDValue?
        public let info:                   String?
        public let name:                   String
        public let org:                    Organization.IDValue?
        public let updatedAt:              Date?
        public let user:                   User.IDValue?
    }
    
    public func created() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}

extension Sequence where Element: Component {
    /// Convert each item in the collection to a public representation object.
    public func objectDatas() async throws -> [Element.ObjectData] {
        var items = [Element.ObjectData]()
        for item in self {
            let data = try item.objectData()
            items.append(data)
        }
        return items
    }
}
