//
//  Plate.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/23/22.
//

import Fluent
import Vapor

public final class Plate: Model, Content {
    public static let schema = "plates"
    
    // MARK: Properties
    @OptionalField(key: "assignee")                                             public var assignee:               User.IDValue?
    @Field(key: "completed")                                                    public var completed:              Bool
    @OptionalField(key: "component")                                            public var component:              Component.IDValue?
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                 public var createdAt:              Date?
    @OptionalField(key: "createdBy")                                            public var createdBy:              User.IDValue?
    @OptionalField(key: "dueDate")                                              public var dueDate:                Date?
    @OptionalField(key: "finishedOn")                                           public var finishedOn:             Date?
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                         public var id:                     UUID?
    @OptionalField(key: "info")                                                 public var info:                   String?
    @OptionalField(key: "manager")                                              public var manager:                User.IDValue?
    @Field(key: "maxCount")                                                     public var maxCount:               Int
    @Field(key: "name")                                                         public var name:                   String
    @OptionalField(key: "reporter")                                             public var reporter:               User.IDValue?
    @OptionalField(key: "reviewer")                                             public var reviewer:               User.IDValue?
    @OptionalField(key: "startedOn")                                            public var startedOn:              Date?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                 public var updatedAt:              Date?
    
    // MARK: Parent
    @Parent(key: "tableID")                                                     public var table:                  TableSpace
    
    // MARK: Children
    @Children(for: \.$plate)                                                    public var items:                  [Plate.Item]

    // MARK: Siblings
    @Siblings(through: PlateOrgPivot.self, from: \.$plate, to: \.$org)          public var orgs:                   [Organization]
    @Siblings(through: PlateUserPivot.self, from: \.$plate, to: \.$user)        public var team:                   [User]
    
    // MARK: Initializers
    public init() {}
    
    public init(table: TableSpace.IDValue, assignee: User.IDValue?, completed: Bool, dueDate: Date?, finishedOn: Date?, createdBy: User.IDValue?, info: String?, manager: User.IDValue?, maxCount: Int, reporter: User.IDValue?, reviewer: User.IDValue?, startedOn: Date?, name: String) {
        self.$table.id = table
        self.assignee = assignee
        self.completed = completed
        self.dueDate = dueDate
        self.finishedOn = finishedOn
        self.createdBy = createdBy
        self.dueDate = dueDate
        self.info = info
        self.manager = manager
        self.maxCount = maxCount
        self.reporter = reporter
        self.reviewer = reviewer
        self.startedOn = startedOn
        self.name = name
    }
    
    convenience public init(data: ObjectData) {
        self.init(table: data.table, assignee: data.assignee, completed: data.completed, dueDate: data.dueDate, finishedOn: data.finishedOn, createdBy: data.createdBy, info: data.info, manager: data.manager, maxCount: data.maxCount, reporter: data.reporter, reviewer: data.reviewer, startedOn: data.startedOn, name: data.name)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, using database: Database) async throws {
        if self.completed != data.completed {
            self.completed = data.completed
        }
        if self.component != data.component {
            self.component = data.component
        }
        if let dueDate = data.dueDate, dueDate != self.dueDate {
            self.dueDate = dueDate
        }
        if let finishedOn = data.finishedOn, self.finishedOn != finishedOn {
            self.finishedOn = finishedOn
        }
        if let newInfo = data.info, self.info != newInfo {
            self.info = newInfo
        }
        if self.maxCount != data.maxCount {
            self.maxCount = data.maxCount
        }
        if let startedOn = data.startedOn, startedOn != self.startedOn {
            self.startedOn = startedOn
        }
        if self.name != data.name {
            self.name = data.name
        }
        if self.assignee != data.assignee {
            self.assignee = data.assignee
        }
        if self.manager != data.manager {
            self.manager = data.manager
        }
        if self.reporter != data.reporter {
            self.reporter = data.reporter
        }
        if self.reviewer != data.reviewer {
            self.reviewer = data.reviewer
        }
        
        try await self.save(on: database)
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(assignee: self.assignee, completed: self.completed, component: self.component, createdAt: self.createdAt, createdBy: self.createdBy, dueDate: self.dueDate, finishedOn: self.finishedOn, id: self.requireID(), info: self.info, manager: self.manager, maxCount: self.maxCount, name: self.name, reporter: self.reporter, reviewer: self.reviewer, startedOn: self.startedOn, table: self.$table.id, updatedAt: self.updatedAt)
    }
}

extension Plate {
    public struct ObjectData: Content {
        public let assignee:       User.IDValue?
        public let completed:      Bool
        public let component:      Component.IDValue?
        public let createdAt:      Date?
        public let createdBy:      User.IDValue?
        public let dueDate:        Date?
        public let finishedOn:     Date?
        public let id:             Plate.IDValue?
        public let info:           String?
        public let manager:        User.IDValue?
        public let maxCount:       Int
        public let name:           String
        public let reporter:       User.IDValue?
        public let reviewer:       User.IDValue?
        public let startedOn:      Date?
        public let table:          TableSpace.IDValue
        public let updatedAt:      Date?
    }
    
    public func created() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}

extension Sequence where Element: Plate {
    /// Convert each item in the collection to a public representation object.
    public func objectDatas() async throws -> [Element.ObjectData] {
        var plates = [Plate.ObjectData]()
        for plate in self {
            let data = try plate.objectData()
            plates.append(data)
        }
        return plates
    }
}
