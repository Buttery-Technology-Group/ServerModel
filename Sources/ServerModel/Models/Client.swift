//
//  Client.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/17/22.
//

import Fluent
import JWT
import Vapor

public final class Client: Model, Content {
    public static let schema = "clients"
    
    // MARK: Properties
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)     public var createdAt:              Date?
    @Timestamp(key: "deletedAt", on: .delete, format: .iso8601)     public var deletedAt:              Date?
    @Field(key: "email")                                            public var email:                  String
    /// The unique identifier for the user. Created automatically by the database.
    @ID                                                             public var id:                     UUID?
    @Field(key: "name")                                             public var name:                   String
    
    public init() {}
    
    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    convenience public init(from data: ObjectData) {
        self.init(name: data.name, email: data.email)
    }
}

extension Client {
    public struct ObjectData: Content {
        public let email:      String
        public let id:         Client.IDValue?
        public let name:       String
    }
    
    public func creationResponse() throws -> CreationResponse {
        return try CreationResponse(id: self.requireID())
    }
}

//extension Client: SessionAuthenticatable {
//    public var sessionID: String {
//        do {
//            return try self.requireID().uuidString
//        } catch {
//            return self.email
//        }
//    }
//}
//
//extension Client {
//    public struct Session: AsyncSessionAuthenticator {
//        typealias User = Client
//        public func authenticate(sessionID: String, for request: Request) async throws {
//            if let foundClient = try await Client.find(UUID(uuidString: sessionID), on: request.db) {
//                request.auth.login(foundClient)
//            } else if let foundClient = try await Client.query(on: request.db).filter(\.$email == sessionID).first() {
//                request.auth.login(foundClient)
//            }
//        }
//    }
//    public struct Bearer: AsyncBearerAuthenticator {
//        public func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
//            if let foundToken = try await Client.Token.query(on: request.db).filter(\.$value == bearer.token).first() {
//                request.auth.login(foundToken.client)
//            }
//        }
//    }
//}

extension Client {
    public final class Token: Model, Content {
        public static let schema = "clientTokens"
        
        // MARK: Properties
        @Field(key: "date")                                         public var date:       Date
        @OptionalField(key: "expiresAt")                            public var expiresAt:  Date?
        @ID                                                         public var id:         UUID?
        @Field(key: "value")                                        public var value:      String
        
        // MARK: Parent
        @Parent(key: "clientID")                                    public var client:     Client

        // MARK: Initializers
        public init() {}
        
        public init(id: UUID? = nil,
             value: String,
             expiresAt: Date? = nil,
             clientID: Client.IDValue)
        {
            self.id = id
            self.value = value
            self.$client.id = clientID
            self.date = Date()
        }
    }
}

extension Client: ModelSessionAuthenticatable {}

extension Client.Token {
    public static func generate(for client: Client) throws -> Self {
        let random = [UInt8].random(count: 16).base64
        return try Self(value: random, clientID: client.requireID())
    }
}

extension Client.Token: ModelTokenAuthenticatable {
    public static let valueKey = \Client.Token.$value
    public static let userKey = \Client.Token.$client

    public var isValid: Bool {
        guard let expiryDate = self.expiresAt else {
            return true
        }
        
        return expiryDate > Date()
    }
}
