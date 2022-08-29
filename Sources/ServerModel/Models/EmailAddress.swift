//
//  EmailAddress.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 6/26/22.
//

import Fluent
import Vapor

public final class EmailAddress: Model, Content {
    public static let schema = "emailAddresses"

    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:          Date?
    /// The unique identifier for the email address. Created automatically by the database.
    @ID(key: .id)                                                   public var id:                 UUID?
    @Field(key: "isPrimary")                                        public var isPrimary:          Bool
    @Field(key: "isVerified")                                       public var isVerified:         Bool
    @Timestamp(key: "updatedAt", on: .update)                       public var updatedAt:          Date?
    @Field(key: "value")                                            public var value:              String

    //MARK: Parent
    @Parent(key: "userID")                                          public var user:               User

    // MARK: Initializers
    public init() {}
    
    public init(_ value: String,
         isPrimary: Bool,
         userID: User.IDValue)
    {
        self.value = value
        self.isPrimary = isPrimary
        self.isVerified = false
        self.$user.id = userID
    }
    
    convenience public init(data: ObjectData) {
        self.init(data.value, isPrimary: data.isPrimary, userID: data.userID)
    }
}

extension EmailAddress {
    public struct ObjectData: Content {
        public let createdAt:          Date?
        public let id:                 EmailAddress.IDValue?
        public let isPrimary:          Bool
        public let isVerified:         Bool
        public let updatedAt:          Date?
        public let userID:             User.IDValue
        public let value:              String
    }
    
    public func objectData() throws -> ObjectData {
        guard let createdAt = self.createdAt else {
            throw Abort(.internalServerError)
        }
        
        return ObjectData(createdAt: createdAt, id: try self.requireID(), isPrimary: self.isPrimary, isVerified: self.isVerified, updatedAt: self.updatedAt, userID: try self.user.requireID(), value: self.value)
    }
}

extension Sequence where Element: EmailAddress {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [EmailAddress.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}

extension Sequence where Self == Array<EmailAddress> {
    public func objectDatas() throws -> [EmailAddress.ObjectData] {
        return try self.compactMap { try $0.objectData() }
    }
}
