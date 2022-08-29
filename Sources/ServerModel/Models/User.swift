//
//  User.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 6/26/22.
//

import Fluent
import SwiftBSON
import Vapor

public final class User: Model, Content {
    public static let schema = "users"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                         public var createdAt:              Date?
    @OptionalField(key: "createdBy")                                                    public var createdBy:              User.IDValue?
    @Field(key: "defaultEmail")                                                         public var defaultEmail:           String
    @Timestamp(key: "deletedAt", on: .delete, format: .iso8601)                         public var deletedAt:              Date?
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                                                 public var id:                     UUID?
    /// The last timestamp when the user logged in
    @OptionalField(key: "lastLogin")                                                    public var lastLogin:              Date?
    /// Whether or not the user is currently online
    @Field(key: "isOnline")                                                             public var isOnline:               Bool
    @Field(key: "name")                                                                 public var name:                   String
    @Field(key: "password")                                                             public var password:               String
    @OptionalField(key: "physicalAddress")                                              public var physicalAddress:        String?
    @OptionalField(key: "siwaIdentifier")                                               public var siwaIdentifier:         String?
    @Field(key: "systemAccess")                                                         public var systemAccess:           SystemAccess
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                         public var updatedAt:              Date?
    @Field(key: "username")                                                             public var username:               String

    // MARK: Children
    @OptionalChild(for: \.$user)                                                        public var plan:                   Plan?
    @Children(for: \.$user)                                                             public var addresses:              [Address]
    @Children(for: \.$user)                                                             public var components:             [Component]
    @Children(for: \.$user)                                                             public var emailAddresses:         [EmailAddress]
    @Children(for: \.$user)                                                             public var events:                 [KeystoneEvent]
    @Children(for: \.$user)                                                             public var projects:               [Project]
    @Children(for: \.$user)                                                             public var settings:               [Settings]
    @Children(for: \.$user)                                                             public var tables:                 [TableSpace]
    @Children(for: \.$user)                                                             public var tokens:                 [User.Token]
    
    // MARK: Siblings
    @Siblings(through: PlateUserPivot.self, from: \.$user, to: \.$plate)                public var plates:                 [Plate]
    @Siblings(through: UserOrganizationPivot.self, from: \.$user, to: \.$org)           public var orgs:                   [Organization]

    // MARK: Initializers
    public init() {}
    
    /// Create user with the given values
    public init(name: String,
         username: String,
         password: String,
         createdBy userID: User.IDValue? = nil)
    {
        self.name = name
        self.username = username
        self.password = password
        self.isOnline = true
        self.createdBy = userID
    }
    
    public init(name: String, defaultEmail: String, password: String, createdBy userID: User.IDValue? = nil) {
        self.name = name
        self.defaultEmail = defaultEmail
        self.password = password
        self.createdBy = createdBy
        if let hexString = SwiftBSON.BSON.init(arrayLiteral: .maxKey).objectIDValue?.hex {
            self.username = name + hexString
        } else {
            self.username = name + Int.random(in: 0...100000).description
        }
    }
    
    convenience public init(siwa: SIWAObjectData) {
        self.init(name: siwa.name, defaultEmail: siwa.email, password: siwa.password)
    }
    
    convenience public init(data: User.ObjectData) throws {
        guard let createdBy = data.createdBy, let defaultEmail = data.defaultEmail, let name = data.name, let password = data.password, let username = data.username else {
            throw Abort(.badRequest)
        }
        self.init(name: name, username: username, password: password, createdBy: createdBy)
        self.systemAccess = data.systemAccess ?? .basic
        self.defaultEmail = defaultEmail
        self.physicalAddress = data.physicalAddress
    }
    
    // MARK: Methods
    public func update(data: ObjectData, from db: Database) async throws {
        if let newAccess = data.systemAccess, self.systemAccess != newAccess {
            self.systemAccess = newAccess
        }
        if let defaultEmail = data.defaultEmail, self.defaultEmail != defaultEmail {
            self.defaultEmail = defaultEmail
            
            if let foundDefaultEmail = try await self.$emailAddresses.query(on: db).filter(\.$value == defaultEmail).first() {
                foundDefaultEmail.isPrimary = true
                try await foundDefaultEmail.save(on: db)
            } else {
                let newEmail = EmailAddress(defaultEmail, isPrimary: true, userID: try self.requireID())
                try await self.$emailAddresses.create(newEmail, on: db)
            }
        }
        if let name = data.name, self.name != name {
            self.name = name
        }
        if let physicalAddress = data.physicalAddress, self.physicalAddress != physicalAddress {
            self.physicalAddress = physicalAddress
        }
        if let username = data.username, self.username != username {
            self.username = username
        }
    }
}

// MARK: - CreationResonse
extension User {
    public func created() throws -> CreationResponse {
        return CreationResponse(id: try self.requireID())
    }
}

// MARK: - ObjectData
extension User {
    /// An object sent to the server to create or update a user.
    ///
    /// When creating a user, the following are required:
    /// - Required: `defaultEmail`,  `name`, `password`, `username`
    ///
    /// When updating a user, the following are required:
    /// - Required: `id` 
    public struct ObjectData: Content {
        public let createdAt:              Date?
        public let createdBy:              User.IDValue?
        public let defaultEmail:           String?
        public let id:                     User.IDValue?
        public let name:                   String?
        public let password:               String?
        public let physicalAddress:        String?
        public let systemAccess:           SystemAccess?
        public let username:               String?
        
        public func user() throws -> User {
            return try User(data: self)
        }
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, createdBy: self.createdBy, defaultEmail: self.defaultEmail, id: self.requireID(), name: self.name, password: self.password, physicalAddress: self.physicalAddress, systemAccess: self.systemAccess, username: self.username)
    }
}

extension Sequence where Element: User {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}

// MARK: - Decodable from SignInWith...
extension User {
    /// An object generated by using **SignInWithApple** or **SignInWithGoogle** and sent to the server to create a new user.
    public struct SIWAObjectData: Content {
        public let name:                   String
        public let password:               String
        public let email:                  String
        public let token:                  String
    }
}

// MARK: - ModelAuthenticable
extension User: ModelAuthenticatable {
    public static let usernameKey = \User.$username
    public static let passwordHashKey = \User.$password
    
    public func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
    }
}

extension User: ModelSessionAuthenticatable {}
extension User: ModelCredentialsAuthenticatable {}
