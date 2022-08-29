//
//  SessionSource.swift
//  
//
//  Created by Jonathan Holland on 7/17/22.
//

import Fluent
import Vapor

public enum SessionSource: Int, Codable {
    case signup, login
}
