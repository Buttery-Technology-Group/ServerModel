//
//  Pivots.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/15/22.
//

import Fluent
import Foundation

public final class UserOrganizationPivot: Model {
    public static let schema = "user-organization-pivot"

    @Field(key: "systemAccess")         public var access:     SystemAccess
    @ID                                 public var id:         UUID?
    @Parent(key: "orgID")               public var org:        Organization
    @Parent(key: "userID")              public var user:       User
    
    public init() {}
    
    public init(orgID: Organization.IDValue, userID: User.IDValue, access: SystemAccess) {
        self.access = access
        self.$org.id = orgID
        self.$user.id = userID
    }
}

public final class ProjectLabelPivot: Model {
    public static let schema = "project-label-pivot"
    
    @ID(key: .id)               public var id:         UUID?
    @Parent(key: "labelID")     public var label:      Label
    @Parent(key: "projectID")   public var project:    Project
    
    public init() {}
    
    public init(id: UUID? = nil, project: Project, label: Label) throws {
        self.id = id
        self.$project.id = try project.requireID()
        self.$label.id = try label.requireID()
    }
    
    public init(projectID: Project.IDValue, labelID: Label.IDValue) {
        self.$project.id = projectID
        self.$label.id = labelID
    }
}

public final class SoftwareLabelPivot: Model {
    public static let schema = "software-label-pivot"
    
    @ID(key: .id)               public var id:         UUID?
    @Parent(key: "labelID")     public var label:      Label
    @Parent(key: "softwareID")  public var software:   Software
    
    public init() {}
    
    public init(id: UUID? = nil, software: Software, label: Label) throws {
        self.id = id
        self.$software.id = try software.requireID()
        self.$label.id = try label.requireID()
    }
    
    public init(softwareID: Software.IDValue, labelID: Label.IDValue) {
        self.$software.id = softwareID
        self.$label.id = labelID
    }
}

public final class PlateItemLabelPivot: Model {
    public static let schema = "plate_item-label-pivot"
    
    @ID(key: .id)                   public var id:         UUID?
    @Parent(key: "labelID")         public var label:      Label
    @Parent(key: "plateItemID")     public var item:       Plate.Item
    
    public init() {}
    
    public init(id: UUID? = nil, item: Plate.Item, label: Label) throws {
        self.id = id
        self.$item.id = try item.requireID()
        self.$label.id = try label.requireID()
    }
    
    public init(itemID: Plate.Item.IDValue, labelID: Label.IDValue) {
        self.$item.id = itemID
        self.$label.id = labelID
    }
}

public final class PlateUserPivot: Model {
    public static let schema = "plate-user-pivot"

    @ID                         public var id:             UUID?
    @Parent(key: "plateID")     public var plate:          Plate
    @Parent(key: "userID")      public var user:           User
    
    public init() {}

    public init(id: UUID? = nil, plate: Plate, user: User) throws {
        self.id = id
        self.$plate.id = try plate.requireID()
        self.$user.id = try user.requireID()
    }
    
    public init(plateID: Plate.IDValue, userID: User.IDValue) {
        self.$plate.id = plateID
        self.$user.id = userID
    }
}

public final class PlateOrgPivot: Model {
    public static let schema = "plate-org-pivot"
    
    @ID                         public var id:             UUID?
    @Parent(key: "orgID")       public var org:            Organization
    @Parent(key: "plateID")     public var plate:          Plate
    
    public init() {}

    public init(id: UUID? = nil, plate: Plate, org: Organization) throws {
        self.id = id
        self.$plate.id = try plate.requireID()
        self.$org.id = try org.requireID()
    }
    
    public init(plateID: Plate.IDValue, orgID: Organization.IDValue) {
        self.$plate.id = plateID
        self.$org.id = orgID
    }
}

public final class UserTablePivot: Model {
    public static let schema = "user-table-pivot"
    
    @ID                         public var id:                 UUID?
    @Parent(key: "tableID")     public var table:              TableSpace
    @Parent(key: "userID")      public var user:               User
    
    public init() {}
    
    public init(table: TableSpace, user: User) throws {
        self.$table.id = try table.requireID()
        self.$user.id = try user.requireID()
    }
    
    public init(tableID: TableSpace.IDValue, userID: User.IDValue) {
        self.$table.id = tableID
        self.$user.id = userID
    }
}
