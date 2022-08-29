//
//  Software+Version.swift
//  
//
//  Created by Jonathan Holland on 7/15/22.
//

import Fluent
import Vapor

extension Software {
    public final class Version: Model, Content {
        public static let schema = "softwareVersions"

        // MARK: Properties
        @OptionalField(key: "component")                                public var component:               String?
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:               Date?
        @Field(key: "createdBy")                                        public var createdBy:               User.IDValue
        @OptionalField(key: "depreciatedAt")                            public var depreciatedAt:           Date?
        /// The unique identifier for the user. Created automatically by the database.
        @ID(key: .id)                                                   public var id:                      UUID?
        @Field(key: "info")                                             public var info:                    String
        @OptionalField(key: "milestone")                                public var milestone:               String?
        @Field(key: "name")                                             public var name:                    String
        @OptionalField(key: "releasedAt")                               public var releasedAt:              Date?
        @Field(key: "stage")                                            public var stage:                   Version.Stage
        @OptionalField(key: "startedAt")                                public var startedAt:               Date?
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:               Date?

        // MARK: Parent
        @Parent(key: "softwareID")                                      public var software:                Software

        // MARK: Children
        @Children(for: \.$version)                                      public var events:                  [KeystoneEvent]
        
        // MARK: Initializers
        public init() {}
        
        public init(name: String, stage: Software.Version.Stage, info: String, component: String?, milestone: String?, createdBy: User.IDValue, software: Software.IDValue) {
            self.name = name
            self.info = info
            self.component = component
            self.milestone = milestone
            self.createdBy = createdBy
            self.$software.id = software
        }
    }
}

extension Software.Version {
    public struct ObjectData: Content {
        public let component:          String?
        public let createdAt:          Date?
        public let createdBy:          User.IDValue
        public let depreciatedAt:      Date?
        public let id:                 Software.Version.IDValue?
        public let info:               String
        public let milestone:          String?
        public let name:               String
        public let releasedAt:         Date?
        public let softwareID:         Software.IDValue
        public let stage:              Software.Version.Stage
        public let startedAt:          Date?
        public let updatedAt:          Date?
    }

    public func objectData() throws -> ObjectData {
        return try ObjectData(component: self.component, createdAt: self.createdAt, createdBy: self.createdBy, depreciatedAt: self.depreciatedAt, id: self.requireID(), info: self.info, milestone: self.milestone, name: self.name, releasedAt: self.releasedAt, softwareID: self.$software.id, stage: self.stage, startedAt: self.startedAt, updatedAt: self.updatedAt)
    }
}

// MARK: Stage
extension Software.Version {
    public enum Stage: String, Codable {
        case preAlpha = "Pre-Alpha", Alpha, Beta, releaseCandidate = "Release Candidate", generalAvailability = "General Availability", Production
    }
}

extension Sequence where Element: Software.Version {
    public func objectDatas() throws -> [Element.ObjectData] {
        return try map { try $0.objectData() }
    }
}
