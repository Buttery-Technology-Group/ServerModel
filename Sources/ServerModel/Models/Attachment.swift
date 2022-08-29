//
//  Attachment.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/16/22.
//

import Fluent
import Vapor

public final class Attachment: Model, Content {
    public static let schema = "attachments"
    
    // MARK: Properties
    @OptionalField(key: "associatedValue")                          public var associatedValue:    String?
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:          Date?
    @OptionalField(key: "data")                                     public var data:               Data?
    @ID(key: .id)                                                   public var id:                 UUID?
    @Field(key: "type")                                             public var type:               ContentType
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:          Date?
    
    // MARK: Parents
    @OptionalParent(key: "plateItemID")                             public var item:               Plate.Item?
    @OptionalParent(key: "projectID")                               public var project:            Project?
    @OptionalParent(key: "userID")                                  public var user:               User?
    
    // MARK: Initializers
    public init() {}
    
    public init(type: ContentType, data: Data?, associatedValue: String?, project: Project.IDValue? = nil, itemID: Plate.Item.IDValue? = nil, userID: User.IDValue? = nil) {
        self.type = type
        self.data = data
        self.associatedValue = associatedValue
        if let project = project {
            self.$project.id = project
        } else if let itemID = itemID {
            self.$item.id = itemID
        } else if let userID = userID {
            self.$user.id = userID
        }
    }
    
    convenience public init(data: ObjectData) {
        self.init(type: data.type, data: data.data, associatedValue: data.associatedValue, project: data.projectID, itemID: data.itemID, userID: data.userID)
    }
    
    // MARK: Methods
    public func update(from data: ObjectData, using database: Database) async throws {
        if self.associatedValue != data.associatedValue {
            self.associatedValue = data.associatedValue
        }
        if self.data != data.data {
            self.data = data.data
        }
        if self.type != data.type {
            self.type = data.type
        }
        if let projectID = data.projectID {
            self.$project.id = projectID
        } else if let itemID = data.itemID {
            self.$item.id = itemID
        } else if let userID = data.userID {
            self.$user.id = userID
        }
        
        try await self.save(on: database)
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(associatedValue: self.associatedValue, createdAt: self.createdAt, data: self.data, id: self.requireID(), type: self.type, updatedAt: self.updatedAt, projectID: self.$project.id, itemID: self.$item.id, userID: self.$user.id)
    }
}

extension Attachment {
    public enum ContentType: String, Codable {
        case audio, image, link, video
    }
}

extension Attachment {
    public struct ObjectData: Content {
        public let associatedValue:        String?
        public let createdAt:              Date?
        public let data:                   Data?
        public let id:                     Attachment.IDValue?
        public let type:                   ContentType
        public let updatedAt:              Date?
        public let projectID:              Project.IDValue?
        public let itemID:                 Plate.Item.IDValue?
        public let userID:                 User.IDValue?
    }
    
    public func created() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}
