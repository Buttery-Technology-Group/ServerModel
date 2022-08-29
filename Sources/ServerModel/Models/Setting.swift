//
//  Setting.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent
import Foundation
import Vapor

public struct Setting: Codable, Content {
    public var authorizedBy:           User.IDValue?
    public var authorizedOn:           Date
    public var category:               CategoryKey
    public var key:                    SettingKey
    public var updatedOn:              Date?
    public var value:                  String
    
    public init(authorizedBy: User.IDValue?, authorizedOn: Date, category: CategoryKey, key: SettingKey, updatedOn: Date?, value: String) {
        self.authorizedBy = authorizedBy
        self.authorizedOn = authorizedOn
        self.category = category
        self.key = key
        self.updatedOn = updatedOn
        self.value = value
    }
    
    public typealias CategoryKey = String
    public typealias SettingKey = String
}

extension Setting.CategoryKey {
    public static let access = "ACCESS"
    public static let general = "GENERAL"
    public static let privacy = "PRIVACY"
}
