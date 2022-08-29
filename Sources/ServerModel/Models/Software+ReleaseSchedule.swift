//
//  Software+ReleaseSchedule.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/17/22.
//

import Fluent
import Vapor

extension Software {
    public final class ReleaseSchedule: Model, Content {
        public static let schema = "softwareReleaseSchedules"
        
        // MARK: Properties
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:              Date?
        @Field(key: "createdBy")                                        public var createdBy:              User.IDValue
        /// The unique identifier for the user. Created automatically by the database.
        @ID(key: .id)                                                   public var id:                     UUID?
        @OptionalField(key: "info")                                     public var info:                   String?
        @OptionalField(key: "milestone")                                public var milestone:              String?
        @OptionalField(key: "plan")                                     public var plan:                   [Plan]?
        @Field(key: "stage")                                            public var stage:                  ReleaseSchedule.Stage
        @OptionalField(key: "targetDate")                               public var targetDate:             Date?
        @OptionalField(key: "title")                                    public var title:                  String?
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:              Date?
        
        // MARK: Parent
        @Parent(key: "softwareID")                                      public var software:               Software

        // MARK: Children
        @Children(for: \.$releaseSchedule)                              public var events:                 [KeystoneEvent]

        // MARK: Initializers
        public init() {}

        public init(stage: ReleaseSchedule.Stage, title: String?, info: String?, milestone: String?, targetDate: Date?, plan: [Plan]?, createdBy: User.IDValue, for softwareID: Software.IDValue) {
            self.stage = stage
            self.title = title
            self.info = info
            self.targetDate = targetDate
            self.createdBy = createdBy
            self.plan = plan
            self.$software.id = softwareID
        }

        convenience public init(data: ObjectData) {
            self.init(stage: data.stage, title: data.title, info: data.info, milestone: data.milestone, targetDate: data.targetDate, plan: data.plan, createdBy: data.createdBy, for: data.softwareID)
        }
    }
}

extension Software.ReleaseSchedule {
    public final class Plan: Fields {
        @Field(key: "stage")            public var stage:              Stage
        @Field(key: "value")            public var value:              String
        
        public init() {}
        
        public init(stage: Stage, value: String) {
            self.stage = stage
            self.value = value
        }
    }

    public enum Stage: String, Codable {
        case Objectives, HighLevelScope = "High-Level Scope", RoughEstimate = "Rough Estimate", ScopeOfImplementation = "Scope of Implementation", TimeframeBudget = "Timeframe & Budget"
    }
}

extension Software.ReleaseSchedule {
    public struct ObjectData: Content {
        public let createdAt:          Date?
        public let createdBy:          User.IDValue
        public let id:                 Software.ReleaseSchedule.IDValue?
        public let info:               String?
        public let milestone:          String?
        public let plan:               [Plan]?
        public let softwareID:         Software.IDValue
        public let stage:              Software.ReleaseSchedule.Stage
        public let targetDate:         Date?
        public let title:              String?
        public let updatedAt:          Date?
        
        public func releaseSchedule() -> Software.ReleaseSchedule {
            return Software.ReleaseSchedule(data: self)
        }
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, id: self.requireID(), info: self.info, milestone: self.milestone, plan: self.plan, softwareID: self.$software.id, stage: self.stage, targetDate: self.targetDate, title: self.title, updatedAt: self.updatedAt)
    }
}

extension Sequence where Element: Software.ReleaseSchedule {
    public func objectDatas() throws -> [Element.ObjectData] {
        return try map { try $0.objectData() }
    }
}
