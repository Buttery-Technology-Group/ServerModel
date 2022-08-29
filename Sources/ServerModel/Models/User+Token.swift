//
//  User+Token.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 6/26/22.
//

import Fluent
import Vapor

extension User {
    public final class Token: Model, Content {
        public static let schema = "userTokens"
        
        // MARK: Properties
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:              Date?
        @OptionalField(key: "expiresAt")                                public var expiresAt:              Date?
        @ID                                                             public var id:                     UUID?
        @Field(key: "value")                                            public var value:                  String
        
        // MARK: Parents
        @Parent(key: "userID")                                          public var user:                   User

        // MARK: Initializers
        public init() {}
        
        public init(id: UUID? = nil, value: String, expiresAt: Date? = nil, userID: User.IDValue) {
            self.id = id
            self.value = value
            self.expiresAt = expiresAt
            self.$user.id = userID
        }
    }
}

extension User.Token {
    public static func generate(for user: User) throws -> User.Token {
        let random = [UInt8].random(count: 16).base64
        return try User.Token(value: random, userID: user.requireID())
    }
}

extension User.Token: ModelTokenAuthenticatable {
    public static let valueKey = \User.Token.$value
    public static let userKey = \User.Token.$user
    public typealias User = ServerModel.User
    
    public var isValid: Bool {
        guard let expiryDate = self.expiresAt else {
            return true
        }
        
        return expiryDate > Date()
    }
}
