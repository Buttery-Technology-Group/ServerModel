//
//  Plan.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent
import Vapor

public final class Plan: Model, Content {
    public static let schema = "plans"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
    @Field(key: "createdBy")                                                            public var createdBy:              User.IDValue
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                 public var id:                     UUID?
    @OptionalField(key: "info")                                                         public var info:                   String?
    @Field(key: "name")                                                                 public var name:                   String
    @Field(key: "percentagePaid")                                                       public var percentagePaid:         Int
    @OptionalField(key: "startDate")                                                    public var startDate:              Date?
    @OptionalField(key: "stripeID")                                                     public var stripeID:               String?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?

    // MARK: Parent
    @OptionalParent(key: "orgID")                                                       public var org:                    Organization?
    @OptionalParent(key: "userID")                                                      public var user:                   User?
    
    // MARK: Children
    @Children(for: \.$plan)                                                             public var events:                 [KeystoneEvent]
    @Children(for: \.$plan)                                                             public var financials:             [Plan.Financial]

    public init() {}
    
    public init(_ name: String, info: String?, startDate: Date?, endDate: Date?, completed: Bool, percentagePaid: Int, stripeID: String?, orgID: Organization.IDValue? = nil, userID: User.IDValue? = nil, by createdBy: User.IDValue) {
        self.name = name
        self.info = info
        self.startDate = startDate
        if let orgID = orgID {
            self.$org.id = orgID
        } else if let userID = userID {
            self.$user.id = userID
        }
        self.percentagePaid = percentagePaid
        self.stripeID = stripeID
        self.createdBy = createdBy
    }
}

extension Plan {
    public struct ObjectData: Content {
        public let createdAt:          Date?
        public let createdBy:          User.IDValue?
        public let events:              [KeystoneEvent.ObjectData]?
        public let financials:         [Plan.Financial.ObjectData]?
        public let id:                 Plan.IDValue?
        public let info:               String?
        public let name:               String
        public let orgID:              Organization.IDValue?
        public let percentagePaid:     Int
        public let startDate:          Date?
        public let stripeID:           String?
        public let updatedAt:          Date?
        public let userID:             User.IDValue?
    }

    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, events: nil, financials: nil, id: self.requireID(), info: self.info, name: self.name, orgID: self.$org.id, percentagePaid: self.percentagePaid, startDate: self.startDate, stripeID: self.stripeID, updatedAt: self.updatedAt, userID: self.$user.id)
    }
}

extension Plan {
    public static func free(user: User?, org: Organization?, by createdBy: User) throws -> Plan {
        return try Plan("Free", info: "Unlimited number of projects and APIs", startDate: Date(), endDate: nil, completed: true, percentagePaid: 100, stripeID: nil, orgID: org?.id, userID: user?.id, by: createdBy.requireID())
    }
}
