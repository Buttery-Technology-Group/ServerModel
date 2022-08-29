//
//  SessionToken.swift
//  
//
//  Created by Jonathan Holland on 7/17/22.
//

import Fluent
import JWT
import Vapor

public struct SessionToken: Content, Authenticatable, JWTPayload {
    // Constants
    public var expirationTime: TimeInterval = 60 * 15

    // Token Data
    public var expiration: ExpirationClaim
    public var userId: UUID

    public init(userId: UUID) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    public init(user: User) throws {
        self.userId = try user.requireID()
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    public func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

public struct ClientTokenReponse: Content {
    public var token: String
}
