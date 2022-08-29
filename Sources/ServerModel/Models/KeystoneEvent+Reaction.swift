//
//  KeystoneEvent+Reaction.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Fluent
import Vapor

extension KeystoneEvent {
    public final class Reaction: Model {
        public static let schema = "keystoneEventReactions"
        
        // MARK: Properties
        /// The unique identifier for the email address. Created automatically by the database.
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:          Date?
        @ID                                                             public var id:                 UUID?
        /// The type of reaction for the event
        ///
        /// Options are: “liked”, “loved”, “excited”, “puzzled”, “disliked”.
        @Field(key: "type")                                             public var type:               String
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)     public var updatedAt:          Date?
        @Field(key: "userID")                                           public var userID:             User.IDValue

        // MARK: Parent
        @Parent(key: "eventID")                                         public var event:              KeystoneEvent

        // MARK: Initializers
        public init() {}
        
        public init(_ type: ReactionType,
             for eventID: KeystoneEvent.IDValue,
             by userID: User.IDValue)
        {
            self.type = type
            self.$event.id = eventID
            self.userID = userID
        }
        
        convenience public init(data: ObjectData) {
            self.init(data.type, for: data.eventID, by: data.userID)
        }
    }
}

// MARK: - Helpers
extension KeystoneEvent.Reaction {
    public typealias ReactionType = String
}

extension KeystoneEvent.Reaction.ReactionType {
    public static let liked = KeystoneEvent.Reaction.ReactionType("liked")
    public static let loved = KeystoneEvent.Reaction.ReactionType("loved")
    public static let excited = KeystoneEvent.Reaction.ReactionType("excited")
    public static let puzzled = KeystoneEvent.Reaction.ReactionType("puzzled")
    public static let disliked = KeystoneEvent.Reaction.ReactionType("disliked")
}

// MARK: - CreationResponse
extension KeystoneEvent.Reaction {
    public func created() throws -> CreationResponse {
        return CreationResponse(id: try self.requireID())
    }
}

// MARK: - ObjectData
extension KeystoneEvent.Reaction {
    public struct ObjectData: Content {
        public let createdAt:       Date?
        public let eventID:         KeystoneEvent.IDValue
        public let id:              KeystoneEvent.Reaction.IDValue
        public let type:            String
        public let updatedAt:       Date?
        public let userID:          User.IDValue
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, eventID: self.$event.id, id: self.requireID(), type: self.type, updatedAt: self.updatedAt, userID: self.userID)
    }
}

extension Sequence where Element: KeystoneEvent.Reaction {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
