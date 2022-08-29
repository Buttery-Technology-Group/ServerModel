//
//  GeneralAccess.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Vapor

public enum GeneralAccess: String, Codable {
    case closed = "CLOSED"
    case NETWORK
    case OPEN
    case org = "ORG"
}
