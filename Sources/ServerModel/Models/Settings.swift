//
//  Settings.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/13/22.
//

import Fluent
import Vapor

public final class Settings: Model, Content {
    public static let schema = "settings"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
    @Field(key: "createdBy")                                                            public var createdBy:              User.IDValue
    @Field(key: "general")                                                              public var general:                [Setting]
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                 public var id:                     UUID?
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?
    
    // MARK: Parents
    @OptionalParent(key: "userID")                                                      public var user:                   User?
    @OptionalParent(key: "projectID")                                                   public var project:                Project?
    @OptionalParent(key: "softwareID")                                                  public var software:               Software?
    
    // MARK: Initializers
    public init() {}
    
    public init(createdBy: User.IDValue, general: [Setting], user: User.IDValue? = nil, project: Project.IDValue? = nil, software: Software.IDValue? = nil) {
        self.createdBy = createdBy
        self.general = general
        if let user = user {
            self.$user.id = user
        } else if let project = project {
            self.$project.id = project
        } else if let software = software {
            self.$software.id = software
        }
    }
    
    convenience public init(data: ObjectData) {
        self.init(createdBy: data.createdBy, general: data.general, user: data.user, project: data.project, software: data.software)
    }
}

extension Settings {
    public struct ObjectData: Codable {
        public let createdAt:       Date?
        public let createdBy:       User.IDValue
        public let general:         [Setting]
        public let id:              Settings.IDValue?
        public let updatedAt:       Date?
        public let user:            User.IDValue?
        public let project:         Project.IDValue?
        public let software:        Software.IDValue?
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, general: self.general, id: self.requireID(), updatedAt: self.updatedAt, user: self.$user.id, project: self.$project.id, software: self.$software.id)
    }
}

extension Sequence where Element: Settings {
    public func objectDatas() throws -> [Element.ObjectData] {
        return try map { try $0.objectData() }
    }
}
