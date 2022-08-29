//
//  SystemAccess.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/7/22.
//

import Vapor

public enum SystemAccess: Int, Codable {
    /// This access means the user doesn't have any read/write access.
    ///
    /// Typically, this would mean the user was terminated from the organization or deleted.
    case none = 0
    /// This access means read only
    case basic = 1
    /// The access means the user has read and some write access.
    case editor = 2
    /// The access means the user has full read/write access.
    case SUPER = 3
}
