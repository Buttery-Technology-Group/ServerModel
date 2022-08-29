//
//  Plate+Item.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/23/22.
//

import Fluent
import Vapor

extension Plate {
    public final class Item: Model, Content {
        public static let schema = "plateItems"
        
        // MARK: Properties
        @OptionalField(key: "assignee")                                                     public var assignee:               User.IDValue?
        @Field(key: "completed")                                                            public var completed:              Bool
        @OptionalField(key: "completedOn")                                                  public var completedOn:            Date?
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
        @OptionalField(key: "createdBy")                                                    public var createdBy:              User.IDValue?
        @OptionalField(key: "dueDate")                                                      public var dueDate:                Date?
        /// The unique identifier for the user. Created automatically by the database.
        @ID                                                                                 public var id:                     UUID?
        @Field(key: "info")                                                                 public var info:                   String
        @OptionalField(key: "projectID")                                                    public var project:                Project.IDValue?
        @OptionalField(key: "serviceID")                                                    public var service:                Service.IDValue?
        @OptionalField(key: "softwareID")                                                   public var software:               Software.IDValue?
        @Field(key: "stage")                                                                public var stage:                  Stage
        @OptionalField(key: "startDate")                                                    public var startDate:              Date?
        @Field(key: "title")                                                                public var title:                  String
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?
        @OptionalField(key: "ownerID")                                                      public var owner:                  User.IDValue?

        // MARK: Parent
        @Parent(key: "plateID")                                                             public var plate:                  Plate
        
        // MARK: Children
        @Children(for: \.$item)                                                             public var attachments:            [Attachment]
        
        // MARK: Siblings
        @Siblings(through: PlateItemLabelPivot.self, from: \.$item, to: \.$label)           public var labels:                 [Label]
        
        // MARK: Initializers
        public init() {}
        
        public init(assignee: User.IDValue?, completed: Bool, completedOn: Date?, createdBy: User.IDValue?, dueDate: Date?, info: String, startDate: Date?, title: String, stage: Stage, plateID: Plate.IDValue, projectID: Project.IDValue?, serviceID: Service.IDValue?, softwareID: Software.IDValue?, ownerID: User.IDValue?) {
            self.assignee = assignee
            self.completed = completed
            self.completedOn = completedOn
            self.createdBy = createdBy
            self.dueDate = dueDate
            self.info = info
            self.startDate = startDate
            self.title = title
            self.stage = stage
            self.$plate.id = plateID
            if let projectID = projectID {
                self.project = projectID
            } else if let serviceID = serviceID {
                self.service = serviceID
            } else if let softwareID = softwareID {
                self.software = softwareID
            } else if let ownerID = ownerID {
                self.owner = ownerID
            }
        }
        
        convenience public init(data: ObjectData) {
            self.init(assignee: data.assignee, completed: data.completed, completedOn: data.completedOn, createdBy: data.createdBy, dueDate: data.dueDate, info: data.info ?? "", startDate: data.startDate, title: data.title, stage: data.stage, plateID: data.plate, projectID: data.project, serviceID: data.service, softwareID: data.software, ownerID: data.owner)
        }
        
        // MARK: Methods
        public func update(from data: ObjectData, using database: Database) async throws {
            if self.completed != data.completed {
                self.completed = data.completed
            }
            if let dueDate = data.dueDate, dueDate != self.dueDate {
                self.dueDate = dueDate
            }
            if let completedOn = data.completedOn, self.completedOn != completedOn {
                self.completedOn = completedOn
            }
            if let newInfo = data.info, self.info != newInfo {
                self.info = newInfo
            }
            if let startDate = data.startDate, startDate != self.startDate {
                self.startDate = startDate
            }
            if self.title != data.title {
                self.title = data.title
            }
            if self.stage != data.stage {
                self.stage = data.stage
            }
            if let owner = data.owner, self.owner != owner {
                self.owner = owner
            }
            if try self.plate.requireID() != data.plate {
                self.$plate.id = data.plate
            }
            if let attachments = data.attachments {
                let existingAttachments = try await self.$attachments.get(on: database)
                for attachment in attachments {
                    if let attachmentID = attachment.id {
                        if let matchingAttachment = try existingAttachments.first(where: { try $0.requireID() == attachmentID }) {
                            try await matchingAttachment.update(from: attachment, using: database)
                        } else {
                            let newAttachment = Attachment(data: attachment)
                            try await self.$attachments.create(newAttachment, on: database)
                        }
                    }
                }
            }
            
            try await self.save(on: database)
        }
        
        public func objectData(database: Database) async throws -> ObjectData {
            return try await ObjectData(assignee: self.assignee, attachments: self.$attachments.get(on: database).compactMap { try $0.objectData() }, completed: self.completed, completedOn: self.completedOn, createdAt: self.createdAt, createdBy: self.createdBy, dueDate: self.dueDate, id: self.requireID(), info: self.info, plate: self.plate.requireID(), project: self.project, service: self.service, software: self.software, stage: self.stage, startDate: self.startDate, title: self.title, updatedAt: self.updatedAt, owner: self.owner)
        }
    }
}

extension Plate.Item {
    public enum Stage: String, Codable {
        case backlog, toDo, inProgress, review, verify, done
    }
}

extension Plate.Item {
    public struct ObjectData: Content {
        public let assignee:       User.IDValue?
        public let attachments:    [Attachment.ObjectData]?
        public let completed:      Bool
        public let completedOn:    Date?
        public let createdAt:      Date?
        public let createdBy:      User.IDValue?
        public let dueDate:        Date?
        public let id:             Plate.Item.IDValue?
        public let info:           String?
        public let plate:          Plate.IDValue
        public let project:        Project.IDValue?
        public let service:        Service.IDValue?
        public let software:       Software.IDValue?
        public let stage:          Stage
        public let startDate:      Date?
        public let title:          String
        public let updatedAt:      Date?
        public let owner:          User.IDValue?
    }
    
    public func created() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}

extension Sequence where Element: Plate.Item {
    /// Convert each item in the collection to a public representation object.
    public func objectDatas(on database: Database) async throws -> [Element.ObjectData] {
        var items = [Element.ObjectData]()
        for item in self {
            items.append(try await item.objectData(database: database))
        }
        return items
    }
}
