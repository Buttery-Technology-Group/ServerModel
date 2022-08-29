//
//  Software+CustomLifeCycle.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/24/22.
//

import Fluent
import Foundation
import Vapor

extension Software {
    public final class CustomLifeCycle: Model, Content {
        public static let schema = "softwareLifecycles"
        
        // MARK: Properties
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
        @Field(key: "createdBy")                                                            public var createdBy:              User.IDValue
        /// The unique identifier for the user. Created automatically by the database.
        @ID                                                                                 public var id:                     UUID?
        @OptionalField(key: "info")                                                         public var info:                   String?
        @Field(key: "name")                                                                 public var name:                   String
        @Field(key: "position")                                                             public var position:               Int
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?
        
        // MARK: Parent
        @Parent(key: "softwareID")                                                          public var software:               Software
        
        public init() {}
        
        public init(_ name: String, position: Int, info: String?, createdBy: User.IDValue, for softwareID: Software.IDValue) {
            self.name = name
            self.position = position
            self.info = info
            self.createdBy = createdBy
            self.$software.id = softwareID
        }
    }
}

extension Software.CustomLifeCycle {
    public struct ObjectData: Content {
        let createdAt:          Date?
        let createdBy:          User.IDValue
        let id:                 Software.CustomLifeCycle.IDValue?
        let info:               String?
        let name:               String
        let position:           Int
        let softwareID:         Software.IDValue
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, id: self.requireID(), info: self.info, name: self.name, position: self.position, softwareID: self.$software.id)
    }
}

extension Sequence where Element: Software.CustomLifeCycle {
    public func objectDatas() throws -> [Element.ObjectData] {
        return try map { try $0.objectData() }
    }
}
