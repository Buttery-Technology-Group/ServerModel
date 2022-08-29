//
//  KeystoneEvent.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent
import Foundation
import Vapor

public final class KeystoneEvent: Model {
    public static let schema = "keystoneEvents"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:                  Date?
    @Field(key: "createdBy")                                        public var createdBy:                  User.IDValue
    @Field(key: "date")                                             public var date:                       Date
    /// The unique identifier for the email address. Created automatically by the database.
    @ID                                                             public var id:                         UUID?
    @OptionalField(key: "info")                                     public var info:                       String?
    @Field(key: "title")                                            public var title:                      String
    @Field(key: "type")                                             public var type:                       String?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:                  Date?
    
    // MARK: Parents
    @OptionalParent(key: "financialID")                             public var financial:                  Service.Financial?
    @OptionalParent(key: "organizationID")                          public var organization:               Organization?
    @OptionalParent(key: "planID")                                  public var plan:                       Plan?
    @OptionalParent(key: "planFinancialID")                         public var planFinancial:              Plan.Financial?
    @OptionalParent(key: "projectID")                               public var project:                    Project?
    @OptionalParent(key: "releaseScheduleID")                       public var releaseSchedule:            Software.ReleaseSchedule?
    @OptionalParent(key: "serviceID")                               public var service:                    Service?
    @OptionalParent(key: "softwareID")                              public var software:                   Software?
    @OptionalParent(key: "userID")                                  public var user:                       User?
    @OptionalParent(key: "versionID")                               public var version:                    Software.Version?
    
    // MARK: Children
    @Children(for: \.$event)                                        public var reactions:                  [Reaction]

    // MARK: Initializers
    public init() {}
    
    public init(_ title: String,
         type: String? = nil,
         info: String?,
         on date: Date,
         createdBy: User.IDValue,
         financialID: Service.Financial.IDValue? = nil,
         orgID: Organization.IDValue? = nil,
         planID: Plan.IDValue? = nil,
         planFinancialID: Plan.Financial.IDValue? = nil,
         projectID: Project.IDValue? = nil,
         serviceID: Service.IDValue? = nil,
         softwareID: Software.IDValue? = nil,
         userID: User.IDValue? = nil,
         versionID: Software.Version.IDValue? = nil,
         releaseScheduleID: Software.ReleaseSchedule.IDValue? = nil)
    {
        self.type = type
        self.title = title
        self.info = info
        self.date = date
        self.createdBy = createdBy
        if let financialID = financialID {
            self.$financial.id = financialID
        } else if let orgID = orgID {
            self.$organization.id = orgID
        } else if let projectID = projectID {
            self.$project.id = projectID
        } else if let releaseScheduleID = releaseScheduleID {
            self.$releaseSchedule.id = releaseScheduleID
        } else if let softwareID = softwareID {
            self.$software.id = softwareID
        } else if let versionID = versionID {
            self.$version.id = versionID
        }  else if let userID = userID {
            self.$user.id = userID
        }
    }
}

// MARK: - CreationResponse
extension KeystoneEvent {
    public func created() throws -> CreationResponse {
        return CreationResponse(id: try self.requireID())
    }
}

// MARK: - ObjectData
extension KeystoneEvent {
    public struct ObjectData: Content {
        public let createdAt:              Date?
        public let createdBy:              User.IDValue?
        public let date:                   Date
        public let financialID:            Service.Financial.IDValue?
        public let id:                     KeystoneEvent.IDValue?
        public let info:                   String?
        public let orgID:                  Organization.IDValue?
        public let planID:                 Plan.IDValue?
        public let planFinancialID:        Plan.Financial.IDValue?
        public let projectID:              Project.IDValue?
        public let reactions:              [Reaction.ObjectData]?
        public let releaseScheduleID:      Software.ReleaseSchedule.IDValue?
        public let serviceID:              Service.IDValue?
        public let softwareID:             Software.IDValue?
        public let title:                  String
        public let type:                   String?
        public let updatedAt:              Date?
        public let userID:                 User.IDValue?
        public let versionID:              Software.Version.IDValue?
    }
    
    public func objectData(on database: Database) async throws -> ObjectData {
        return try await ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, date: self.date, financialID: self.$financial.id, id: self.requireID(), info: self.info, orgID: self.$organization.id, planID: self.$plan.id, planFinancialID: self.$planFinancial.id, projectID: self.$project.id, reactions: self.$reactions.get(on: database).objectDatas(), releaseScheduleID: self.$releaseSchedule.id, serviceID: self.$service.id, softwareID: self.$software.id, title: self.title, type: self.type, updatedAt: self.updatedAt, userID: self.$user.id, versionID: self.$version.id)
    }
}

extension Sequence where Element: KeystoneEvent {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas(on database: Database) async throws -> [Element.ObjectData] {
        var events = [Element.ObjectData]()
        for event in self {
            events.append(try await event.objectData(on: database))
        }
        return events
    }
}

// MARK: - Titles and Types
extension KeystoneEvent {
    public enum EmployeeEventTitle: String, Codable {
        case created, deleted, fired, hired, offboarded, onboarded, started
    }
    
    public enum EventType: String, Codable {
        case history, comment
    }
}
