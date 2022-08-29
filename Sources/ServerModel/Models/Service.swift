//
//  Service.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/20/22.
//

import Fluent
import Vapor

public final class Service: Model, Content {
    public static let schema = "services"
    
    // MARK: Properties
    @Field(key: "completed")                                                            public var completed:              Bool
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
    @Field(key: "createdBy")                                                            public var createdBy:              User.IDValue
    @OptionalField(key: "endDate")                                                      public var endDate:                Date?
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                 public var id:                     UUID?
    @OptionalField(key: "info")                                                         public var info:                   String?
    @Field(key: "name")                                                                 public var name:                   String
    @Field(key: "percentagePaid")                                                       public var percentagePaid:         Int
    @OptionalField(key: "startDate")                                                    public var startDate:              Date?
    @OptionalField(key: "stripeID")                                                     public var stripeID:               String?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?

    // MARK: Parent
    @Parent(key: "projectID")                                                           public var project:                Project

    // MARK: Children
    @Children(for: \.$service)                                                          public var events:                 [KeystoneEvent]
    @Children(for: \.$service)                                                          public var financials:             [Service.Financial]

    public init() {}
    
    public init(_ name: String, info: String?, startDate: Date?, endDate: Date?, completed: Bool, percentagePaid: Int, stripeID: String?, for projectID: Project.IDValue, by createdBy: User.IDValue) {
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.$project.id = projectID
        self.completed = completed
        self.percentagePaid = percentagePaid
        self.stripeID = stripeID
        self.createdBy = createdBy
    }
}

extension Service {
    public struct ObjectData: Content {
        public let completed:          Bool
        public let createdAt:          Date?
        public let createdBy:          User.IDValue
        public let endDate:            Date?
        public let financials:         [Service.Financial.ObjectData]?
        public let id:                 Service.IDValue?
        public let info:               String?
        public let name:               String
        public let percentagePaid:     Int
        public let projectID:          Project.IDValue
        public let startDate:          Date?
        public let stripeID:           String?
        public let updatedAt:          Date?
    }
    
    public func objectData(on database: Database) async throws -> ObjectData {
        return try await ObjectData(completed: self.completed, createdAt: self.createdAt, createdBy: self.createdBy, endDate: self.endDate, financials: self.$financials.get(on: database).objectDatas(), id: self.requireID(), info: self.info, name: self.name, percentagePaid: self.percentagePaid, projectID: self.$project.id, startDate: self.startDate, stripeID: self.stripeID, updatedAt: self.updatedAt)
    }
}

extension Sequence where Element: Service {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas(on database: Database) async throws -> [Element.ObjectData] {
        var events = [Element.ObjectData]()
        for event in self {
            events.append(try await event.objectData(on: database))
        }
        return events
    }
}
