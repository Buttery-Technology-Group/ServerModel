//
//  TableSpace.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/25/22.
//

import Fluent
import Vapor

public final class TableSpace: Model, Content {
    public static let schema = "tableSpaces"
    
    // MARK: Properties
    @OptionalField(key: "assignee")                                         public var assignee:               User.IDValue?
    @Field(key: "completed")                                                public var completed:              Bool
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)             public var createdAt:              Date?
    @OptionalField(key: "createdBy")                                        public var createdBy:              User.IDValue?
    @OptionalField(key: "dueDate")                                          public var dueDate:                Date?
    @OptionalField(key: "finishedOn")                                       public var finishedOn:             Date?
    @ID                                                                     public var id:                     UUID?
    @OptionalField(key: "info")                                             public var info:                   String?
    @OptionalField(key: "manager")                                          public var manager:                User.IDValue?
    @Field(key: "maxCount")                                                 public var maxCount:               Int
    @Field(key: "name")                                                     public var name:                   String
    @OptionalField(key: "reviewer")                                         public var reviewer:               User.IDValue?
    @OptionalField(key: "startedOn")                                        public var startedOn:              Date?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)             public var updatedAt:              Date?
    
    // MARK: Parents
    @OptionalParent(key: "userID")                                          public var user:                   User?
    @OptionalParent(key: "orgID")                                           public var org:                    Organization?
    
    // MARK: Children
    @Children(for: \.$table)                                                public var plates:                 [Plate]
    
    // MARK: Siblings
    @Siblings(through: UserTablePivot.self, from: \.$table, to: \.$user)    public var members:                [User]
    
    // MARK: Initializers
    public init() {}
    
    public init(assignee: User.IDValue?, completed: Bool, dueDate: Date?, finishedOn: Date?, id: UUID? = nil, info: String?, manager: User.IDValue?, maxCount: Int, name: String, reviewer: User.IDValue?, startedOn: Date?, userID: User.IDValue?, orgID: Organization.IDValue?) {
        self.assignee = assignee
        self.completed = completed
        self.dueDate = dueDate
        self.finishedOn = finishedOn
        self.id = id
        self.info = info
        self.manager = manager
        self.maxCount = maxCount
        self.name = name
        self.reviewer = reviewer
        self.startedOn = startedOn
        if let userID = userID {
            self.$user.id = userID
        }
        if let orgID = orgID {
            self.$org.id = orgID
        }
    }
    
    convenience public init(data: ObjectData) {
        self.init(assignee: data.assignee, completed: data.completed, dueDate: data.dueDate, finishedOn: data.finishedOn, info: data.info, manager: data.manager, maxCount: data.maxCount, name: data.name, reviewer: data.reviewer, startedOn: data.startedOn, userID: data.user, orgID: data.org)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, using database: Database) async throws {
        if self.completed != data.completed {
            self.completed = data.completed
        }
        if self.dueDate != data.dueDate {
            self.dueDate = data.dueDate
        }
        if self.finishedOn != data.finishedOn {
            self.finishedOn = data.finishedOn
        }
        if self.info != data.info {
            self.info = data.info
        }
        if self.maxCount != data.maxCount {
            self.maxCount = data.maxCount
        }
        if self.name != data.name {
            self.name = data.name
        }
        if self.$user.id != data.user {
            self.$user.id = data.user
        }
        if $org.id != data.org {
            self.$org.id = data.org
        }
        if self.assignee != data.assignee {
            self.assignee = data.assignee
        }
        if self.manager != data.manager {
            self.manager = data.manager
        }
        if self.reviewer != data.reviewer {
            self.reviewer = data.reviewer
        }
        
        try await self.save(on: database)
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(assignee: self.assignee, completed: self.completed, createdAt: self.createdAt, createdBy: self.createdBy, dueDate: self.dueDate, finishedOn: self.finishedOn, id: self.requireID(), info: self.info, manager: self.manager, maxCount: self.maxCount, reviewer: self.reviewer, name: self.name, startedOn: self.startedOn, org: self.$org.id, updatedAt: self.updatedAt, user: self.$user.id)
    }
}

extension TableSpace {
    public struct ObjectData: Content {
        public let assignee:               User.IDValue?
        public let completed:              Bool
        public let createdAt:              Date?
        public let createdBy:              User.IDValue?
        public let dueDate:                Date?
        public let finishedOn:             Date?
        public let id:                     TableSpace.IDValue?
        public let info:                   String?
        public let manager:                User.IDValue?
        public let maxCount:               Int
        public let reviewer:               User.IDValue?
        public let name:                   String
        public let startedOn:              Date?
        public let org:                    Organization.IDValue?
        public let updatedAt:              Date?
        public let user:                   User.IDValue?
    }
    
    public func created() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}

extension Sequence where Element: TableSpace {
    /// Convert each item in the collection to a public representation object.
    public func objectDatas() async throws -> [Element.ObjectData] {
        var tables = [Element.ObjectData]()
        for table in self {
            let data = try table.objectData()
            tables.append(data)
        }
        return tables
    }
}
