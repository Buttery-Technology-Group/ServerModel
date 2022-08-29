//
//  HelperObjects.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/22/22.
//

import Fluent
import Vapor

public struct BoolResponse: Content {
    public let value: Bool
    
    public init(_ value: Bool) {
        self.value = value
    }
}

/// The response containing the ID sent back when an object is created and successfully saved
public struct CreationResponse: Content {
    public let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
