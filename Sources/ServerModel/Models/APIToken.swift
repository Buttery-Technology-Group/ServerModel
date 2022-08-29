//
//  APIToken.swift
//  
//
//  Created by Jonathan Holland on 7/17/22.
//

import Fluent
import Vapor

public final class APIToken: Model, Content {
    public static let schema = "apiTokens"
    
    // MARK: Properties
    @Field(key: "date")         public var date:       Date
    @ID                         public var id:         UUID?
    @Field(key: "value")        public var value:      String
    
    // MARK: Parent
    @Parent(key: "userID")      public var user:       User

    // MARK: Initializers
    public init() {}
    
    public init(id: UUID? = nil,
         value: String,
         userID: User.IDValue)
    {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.date = Date()
    }
}

extension APIToken {
    public static func generate(for user: User) throws -> Self {
        let random = [UInt8].random(count: 16).base64
        return try Self(value: random, userID: user.requireID())
    }
}

extension APIToken: ModelTokenAuthenticatable {
    public static let valueKey = \APIToken.$value
    public static let userKey = \APIToken.$user
    
    public var isValid: Bool {
        return true
    }
}
