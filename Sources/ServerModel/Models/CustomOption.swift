//
//  CustomOption.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/16/22.
//

import Fluent
import Foundation

public final class CustomOption: Fields {
    @Field(key: "associatedData")   public var associatedData:     Data?
    @Field(key: "key")              public var key:                String
    @Field(key: "value")            public var value:              String
    
    public init() {}
    
    public init(key: String, value: String, data: Data? = nil)
    {
        self.key = key
        self.value = value
        self.associatedData = data
    }
}
