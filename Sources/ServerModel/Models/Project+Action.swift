//
//  Project+Action.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/24/22.
//

import Fluent
import Foundation
import Vapor

extension Project {
    /// An object that describes an action that needs to be taken and the associated values.
    public final class Action: Model, Content {
        public static let schema = "projectActions"
        
        // MARK: Properties
        @Field(key: "allowMultipleSelection")                           public var allowMultipleSelection: Bool
        @Field(key: "approved")                                         public var approved:               Bool
        @OptionalField(key: "associatedPrice")                          public var associatedPrice:        String?
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:              Date?
        @OptionalField(key: "createdBy")                                public var createdBy:              User.IDValue?
        @Field(key: "explanation")                                      public var explanation:            String
        /// The unique identifier for the user. Created automatically by the database.
        @ID(key: .id)                                                   public var id:                     UUID?
        @Field(key: "options")                                          public var options:                [Action.Option]
        @Field(key: "selections")                                       public var selections:             [Action.Option]
        @Field(key: "title")                                            public var title:                  String
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:              Date?

        // MARK: Parent
        @Parent(key: "projectID")                                       public var project:                Project

        // MARK: Initializers
        public init() {}
        
        public init(title: String, allowMultipleSelection: Bool, explanation: String, options: [Action.Option], associatedPrice: String?, selections: [Action.Option], approved: Bool, createdBy: User.IDValue?, for project: Project.IDValue) {
            self.title = title
            self.allowMultipleSelection = allowMultipleSelection
            self.explanation = explanation
            self.options = options
            self.associatedPrice = associatedPrice
            self.selections = selections
            self.approved = approved
            self.createdBy = createdBy
            self.$project.id = project
        }
        
        convenience public init(data: ObjectData) {
            self.init(title: data.title, allowMultipleSelection: data.allowMultipleSelection, explanation: data.explanation, options: data.options, associatedPrice: data.associatedPrice, selections: data.selections, approved: data.approved, createdBy: data.createdBy, for: data.projectID)
        }
        
        // MARK: Option
        public final class Option: Fields {
            @OptionalField(key: "associatedPrice")  public var associatedPrice:        String?
            @Field(key: "info")                     public var info:                   String
            @Field(key: "title")                    public var title:                  String
            @Field(key: "userProvidedDetails")      public var userProvidedDetails:    String
            
            public init() {}
                        
            public init(title: String, info: String, userProvidedDetails: String, associatedPrice: String? = nil) {
                self.title = title
                self.info = info
                self.userProvidedDetails = userProvidedDetails
                self.associatedPrice = associatedPrice
            }
        }
    }
}

extension Project.Action {
    /// The object used to decode new projects from JSON
    public struct ObjectData: Content {
        public let allowMultipleSelection:     Bool
        public let approved:                   Bool
        public let associatedPrice:            String?
        public let createdAt:                  Date?
        public let createdBy:                  User.IDValue?
        public let explanation:                String
        public let id:                         Project.Action.IDValue?
        public let options:                    [Project.Action.Option]
        public let projectID:                  Project.IDValue
        public let selections:                 [Project.Action.Option]
        public let title:                      String
        public let updatedAt:                  Date?
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(allowMultipleSelection: self.allowMultipleSelection, approved: self.approved, associatedPrice: self.associatedPrice, createdAt: self.createdAt, createdBy: self.createdBy, explanation: self.explanation, id: self.requireID(), options: self.options, projectID: self.$project.id, selections: self.selections, title: self.title, updatedAt: self.updatedAt)
    }
}

extension Sequence where Element: Project.Action {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
