//
//  Label.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/15/22.
//

import Fluent
import Vapor

public final class Label: Model, Content {
    public static let schema = "labels"
    
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                     public var createdAt:              Date?
    @Field(key: "createdBy")                                                        public var createdBy:              User.IDValue
    /// The unique identifier for the user. Created automatically by the database.
    @ID(key: .id)                                                                   public var id:                     UUID?
    @Field(key: "title")                                                            public var title:                  String
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                     public var updatedAt:              Date?

    // MARK: Siblings
    @Siblings(through: ProjectLabelPivot.self, from: \.$label, to: \.$project)      public var projects:               [Project]
    @Siblings(through: SoftwareLabelPivot.self, from: \.$label, to: \.$software)    public var softwares:              [Software]
    @Siblings(through: PlateItemLabelPivot.self, from: \.$label, to: \.$item)       public var items:                  [Plate.Item]

    public init() {}
    
    public init(title: String, createdBy: User.IDValue) {
        self.title = title
        self.createdBy = createdBy
    }
}

extension Label {
    public struct ObjectData: Content {
        public let createdAt:          Date?
        public let createdBy:          User.IDValue?
        public let id:                 Label.IDValue?
        public let title:              String
        public let updatedAt:          Date?
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, id: self.requireID(), title: self.title, updatedAt: self.updatedAt)
    }
}

extension Sequence where Element: Label {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
