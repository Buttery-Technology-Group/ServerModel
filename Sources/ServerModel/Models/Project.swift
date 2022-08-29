//
//  Project.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/14/22.
//

import Fluent
import Vapor

public final class Project: Model, Content {
    public static let schema = "projects"
    
    // MARK: Properties
    @Group(key: "butteryProfile")                                                   public var butteryProfile:         ButteryProfile
    @Timestamp(key: "createdAt", on: .create, format: .iso8601)                     public var createdAt:              Date?
    @Field(key: "createdBy")                                                        public var createdBy:              User.IDValue
    @Field(key: "generalAccess")                                                    public var generalAccess:          GeneralAccess
    /// The unique identifier for the user. Created automatically by the database.
    @ID(key: .id)                                                                   public var id:                     UUID?
    @OptionalField(key: "logo")                                                     public var logo:                   Data?
    @Field(key: "name")                                                             public var name:                   String
    @Field(key: "status")                                                           public var status:                 Project.Status
    @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                     public var updatedAt:              Date?
    
    // MARK: Parent
    @OptionalParent(key: "orgID")                                                   public var org:                     Organization?
    @OptionalParent(key: "userID")                                                  public var user:                   User?
    
    // MARK: Children
    @Children(for: \.$project)                                                      public var actions:                [Project.Action]
    @Children(for: \.$project)                                                      public var events:                 [KeystoneEvent]
    @Children(for: \.$project)                                                      public var settings:               [Settings]
    @Children(for: \.$project)                                                      public var services:               [Service]
    @Children(for: \.$project)                                                      public var softwares:              [Software]
    
    // MARK: Siblings
    @Siblings(through: ProjectLabelPivot.self, from: \.$project, to: \.$label)      public var labels:                 [Label]
    
    // MARK: Initializers
    public init() {}
    
    public init(name: String, status: Status = .draft, createdBy userID: User.IDValue? = nil, orgID: Organization.IDValue? = nil) {
        self.name = name
        self.status = status
        self.createdBy = createdBy
        if let userID = userID {
            self.$user.id = userID
        } else if let orgID = orgID {
            self.$org.id = orgID
        }
    }
    
    convenience public init(data: ObjectData) {
        self.init(name: data.name, status: data.status, createdBy: data.createdBy!)
        self.logo = data.logo
        self.butteryProfile = ButteryProfile(data: data.butteryProfile)
        self.generalAccess = data.generalAccess ?? .NETWORK
    }
}

extension Project {
    /// The current status that a project has
    ///
    /// A project's lifecycle can be different depending on its needs and budget.
    ///
    ///     `draft` >> `created` >> `initialized` >> `analyzing` >> `inProgress`                          `inProgress` >> `testing` >> `finalizing` >> `completed`
    ///                                                                           ||                  ||
    ///                                                                               `actionNeeded`
    public enum Status: String, Codable {
        /// A status indicating the project has outstanding actions that need to be completed.
        case actionNeeded = "Action needed"
        /// A status indicating the project is being analyzed by Buttery. The next step is either `actionNeeded` or `inProgress`
        case analyzing
        /// A status indicating the project has reached completion and is finished.
        case completed
        /// A status indicating the project has been created. The next step is `initialized`.
        case created
        /// A status indicating the project has *not* been created. The next step is `created`.
        case draft
        /// A status indicating the project has entered the public final phase before completion.
        ///
        /// Typical actions in the public final phase would be archiving the project and applying digital signatures for approval with Apple.
        case finalizing
        /// A status indicating the project is in a state of idle. The next step would be `in-progress`, `analyzing`, or `cancelled`.
        ///
        /// This state would be reached if the state had previously been `paused` for an extended period of time, such as remaining paused for 180 days.
        case idle
        /// A status indicating the project has been initialized by a Buttery team memeber. The next step is `analyzing`.
        case initialized
        /// A status indicating the project is in-progress. The next step is either `paused`, `actionNeeded`, or `testing`.
        case inProgress = "In-progress"
    }
}

extension Project {
    public struct ButteryProfileData: Content {
        public let additions:               [CustomOption]?
        public let appNavigation:           SelectionOption?
        public let customColors:            [CustomOption]?
        public let customFont:              Data?
        public let darkMode:                InterfaceAppearance?
        public let features:                [SelectionOption]?
        public let font:                    FontType?
        public let generalCategory:         GeneralCategory?
        public let importantFeature:        ImportantFeature?
        public let interfaceStyle:          SelectionOption?
        public let platforms:               [SelectionOption]?
    }
    public struct ObjectData: Content {
        public let actions:                 [Project.Action.ObjectData]?
        public let butteryProfile:          ButteryProfileData?
        public let createdAt:               Date?
        public var createdBy:               User.IDValue?
        public let generalAccess:           GeneralAccess?
        public let id:                      Project.IDValue?
        public let labels:                  [Label.ObjectData]?
        public let logo:                    Data?
        public let name:                    String
        public let organization:            Organization.IDValue?
        public let services:                [Service.ObjectData]?
        public let softwares:               [Software.ObjectData]?
        public let status:                  Status
        public let user:                    User.IDValue?
    }
    
    public func objectData(on database: Database) async throws -> ObjectData {
        return try await ObjectData(actions: self.$actions.get(on: database).objectDatas(), butteryProfile: self.butteryProfile.objectData(), createdAt: self.createdAt, createdBy: self.createdBy, generalAccess: self.generalAccess, id: self.requireID(), labels: self.$labels.get(on: database).objectDatas(), logo: self.logo, name: self.name, organization: self.$org.id, services: self.$services.get(on: database).objectDatas(on: database), softwares: self.$softwares.get(on: database).objectDatas(on: database), status: self.status, user: self.$user.id)
    }
}

extension Project {
    public enum InterfaceAppearance: Int, Codable {
        case lightOnly, darkAndLight, darkOnly
    }
    public enum GeneralCategory: String, Codable {
        case entertainment, financialServices = "financial services", hireMyServices = "hire my services", informative, lifestyle, productivity, other, sellMyProducts = "sell my products", socialMedia = "social media", utilities
    }
    public enum ImportantFeature: String, Codable {
        case accessibility, compatibility, coolFeatures = "cool features", design, fast
    }
    public enum Platform: String, Codable {
        case android, iOS, macOS, web, windows
    }
    public enum FontType: Int, Codable {
        case systemDefaults, custom, pickForMe
    }
}

extension Sequence where Element: Project {
    /// Convert each user in the collection to a public representation object.
    public func objectDatas(on database: Database) async throws -> [Element.ObjectData] {
        var events = [Element.ObjectData]()
        for event in self {
            events.append(try await event.objectData(on: database))
        }
        return events
    }
}
