//
//  Software.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/15/22.
//

import Fluent
import Vapor

public final class Software: Model, Content {
    public static let schema = "softwares"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
    @Field(key: "createdBy")                                                            public var createdBy:              User.IDValue
    @Field(key: "generalAccess")                                                        public var generalAccess:          GeneralAccess
   /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                 public var id:                     UUID?
    @OptionalField(key: "info")                                                         public var info:                   String?
    @Field(key: "name")                                                                 public var name:                   String
    @Field(key: "platforms")                                                            public var platforms:              [Platform]
    @OptionalField(key: "releasedAt")                                                   public var releasedAt:             Date?
    @OptionalField(key: "startedAt")                                                    public var startedAt:              Date?
    @Field(key: "stage")                                                                public var stage:                  Software.LifeCycleStage
    @Field(key: "status")                                                               public var status:                 Software.Status
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?
    @Field(key: "useCustomLifeCycle")                                                   public var useCustomLifeCycle:     Bool

    // MARK: Parent
    @Parent(key: "projectID")                                                           public var project:                Project

    // MARK: Siblings
    @Siblings(through: SoftwareLabelPivot.self, from: \.$software, to: \.$label)        public var labels:                 [Label]

    // MARK: Children
    @Children(for: \.$software)                                                         public var events:                 [KeystoneEvent]
    @Children(for: \.$software)                                                         public var customLifecycle:        [Software.CustomLifeCycle]
    @Children(for: \.$software)                                                         public var releaseSchedule:        [ReleaseSchedule]
    @Children(for: \.$software)                                                         public var settings:               [Settings]
    @Children(for: \.$software)                                                         public var versions:               [Version]

    public init() {}
    
    public init(name: String, info: String? = nil, platforms: [Platform], startedAt: Date? = nil, releasedAt: Date? = nil, stage: Software.LifeCycleStage, status: Software.Status, for projectID: Project.IDValue, createdBy: User.IDValue) {
        self.name = name
        self.info = info
        self.platforms = platforms
        self.startedAt = startedAt
        self.releasedAt = releasedAt
        self.$project.id = projectID
        self.createdBy = createdBy
        self.useCustomLifeCycle = false
    }
    
    convenience public init(data: ObjectData) {
        self.init(name: data.name, info: data.info, platforms: data.platforms, startedAt: data.startedAt, releasedAt: data.releasedAt, stage: data.stage, status: data.status, for: data.projectID, createdBy: data.createdBy)
        self.generalAccess = data.generalAccess ?? .NETWORK
    }
}

// MARK: ObjectData
extension Software {
    public struct ObjectData: Content {
        public let createdAt:              Date?
        public let createdBy:              User.IDValue
        public let customLifecycle:         [Software.CustomLifeCycle.ObjectData]?
        public let events:                  [KeystoneEvent.ObjectData]?
        public let generalAccess:          GeneralAccess?
        public let id:                     Software.IDValue?
        public let info:                   String?
        public let name:                   String
        public let platforms:              [Platform]
        public let projectID:              Project.IDValue
        public let releasedAt:             Date?
        public let releaseSchedule:         [ReleaseSchedule.ObjectData]?
        public let settings:                [Settings.ObjectData]?
        public let stage:                  LifeCycleStage
        public let startedAt:              Date?
        public let status:                 Status
        public let updatedAt:              Date?
        public let useCustomLifeCycle:     Bool
        public let versions:                [Version.ObjectData]?
        
        public func convertToSoftware() -> Software {
            return Software(data: self)
        }
    }
    
    public func objectData(on database: Database) async throws -> ObjectData {
        return try await ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, customLifecycle: self.$customLifecycle.get(on: database).objectDatas(), events: nil, generalAccess: self.generalAccess, id: self.requireID(), info: self.info, name: self.name, platforms: self.platforms, projectID: self.$project.id, releasedAt: self.releasedAt, releaseSchedule: self.$releaseSchedule.get(on: database).objectDatas(), settings: self.$settings.get(on: database).objectDatas(), stage: self.stage, startedAt: self.startedAt, status: self.status, updatedAt: self.updatedAt, useCustomLifeCycle: self.useCustomLifeCycle, versions: self.$versions.get(on: database).objectDatas())
    }
}

// MARK: Stage
extension Software {
    public enum LifeCycleStage: String, Codable {
        case Plan, Requirements, designPrototype = "Design & Prototyping", Develope, qaTesting = "QA Testing", Deploy, Maintain
    }
}

extension Software {
    /// The current status that a software has
    ///
    /// A software's lifecycle can be different depending on its needs and budget.
    ///
    ///     `draft` >> `created` >> `initialized` >> `analyzing` >> `inProgress`                          `inProgress` >> `testing` >> `finalizing` >> `completed`
    ///                                                                           ||                  ||
    ///                                                                               `actionNeeded`
    public enum Status: String, Codable {
        /// A status indicating the software has outstanding actions that need to be completed.
        case actionNeeded = "action needed"
        /// A status indicating the software is being analyzed by Buttery. The next step is either `actionNeeded` or `inProgress`
        case analyzing
        /// A status indicating the software has been cancelled.
        case cancelled
        /// A status indicating the software has reached completion and is finished.
        case completed
        /// A status indicating the software has been created. The next step is `initialized`.
        case created
        /// A status indicating the software is being deployed. The next step would be `completed`.
        case deploying
        /// A status indicating the software has *not* been created. The next step is `created`.
        case draft
        /// A status indicating the software has entered the public final phase before completion.
        ///
        /// Typical actions in the public final phase would be archiving the software and applying digital signatures for approval with Apple.
        case finalizing
        /// A status indicating the software is in a state of idle. The next step would be `in-progress`, `analyzing`, or `cancelled`.
        ///
        /// This state would be reached if the state had previously been `paused` for an extended period of time, such as remaining paused for 180 days.
        case idle
        /// A status indicating the software has been initialized by a Buttery team memeber. The next step is `analyzing`.
        case initialized
        /// A status indicating the software is in-progress. The next step is either `paused`, `actionNeeded`, or `testing`.
        case inProgress = "in-progress"
        /// A status indicating the software has been paused indefinitely. The next step is either
        case paused
        /// A status indicating the software is being tested. The next step could be `finalizing` or back to `inProgress` if more work needs to be done.
        case testing
    }
}

extension Sequence where Element: Software {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas(on database: Database) async throws -> [Element.ObjectData] {
        var items = [Element.ObjectData]()
        for item in self {
            items.append(try await item.objectData(on: database))
        }
        return items
    }
}
