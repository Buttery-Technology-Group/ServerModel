//
//  Plan+Financials.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 8/14/22.
//

import Fluent
import Vapor

extension Plan {
    public final class Financial: Model, Content {
        public static let schema = "planFinancials"
        
        // MARK: Properties
        @Field(key: "collected")                                                        public var collected:              Bool
        @Timestamp(key: "createdAt", on: .create, format: .iso8601)                     public var createdAt:              Date?
        /// The string value of the decimal value amount discounted off the service.
        @Field(key: "discount")                                                         public var discount:               String
        /// The unique identifier for the user. Created automatically by the database.
        @ID                                                                             public var id:                     UUID?
        @OptionalField(key: "info")                                                     public var info:                   String?
        @Field(key: "percentagePaid")                                                   public var percentagePaid:         Int
        @OptionalField(key: "stripeID")                                                 public var stripeID:               String?
        @Field(key: "subtotal")                                                         public var subtotal:               String
        /// The string value of the decimal tax amount required for this service.
        @Field(key: "tax")                                                              public var tax:                    String
        @Field(key: "title")                                                            public var title:                  String
        /// The string value of the decimal total amount to satisy this service.
        @Field(key: "total")                                                            public var total:                  String
        @Timestamp(key: "updatedAt", on: .update, format: .iso8601)                     public var updatedAt:              Date?

        // MARK: Parent
        @Parent(key: "planID")                                                          public var plan:                   Plan
        
        // MARK: Children
        @Children(for: \.$planFinancial)                                                public var events:                 [KeystoneEvent]

        public init() {}
        
        public init(_ title: String, info: String?, total: String, subtotal: String, discount: String, tax: String, collected: Bool, percentagePaid: Int, stripeID: String?, for planID: Plan.IDValue) {
            self.title = title
            self.info = info
            self.total = total
            self.subtotal = subtotal
            self.discount = discount
            self.tax = tax
            self.collected = collected
            self.percentagePaid = percentagePaid
            self.stripeID = stripeID
            self.$plan.id = planID
        }
        
        convenience public init(data: ObjectData) {
            self.init(data.title, info: data.info, total: data.total, subtotal: data.subtotal, discount: data.discount, tax: data.tax, collected: data.collected, percentagePaid: data.percentagePaid, stripeID: data.stripedID, for: data.planID)
        }
    }
}

extension Plan.Financial {
    public struct ObjectData: Content {
        public let createdAt:              Date?
        public let collected:              Bool
        public let discount:               String
        public let id:                     Plan.Financial.IDValue?
        public let info:                   String?
        public let percentagePaid:         Int
        public let planID:                 Plan.IDValue
        public let stripedID:              String?
        public let subtotal:               String
        public let tax:                    String
        public let title:                  String
        public let total:                  String
        public let updatedAt:              Date?
    }
    
    public func objectData() throws -> ObjectData {
        return try ObjectData(createdAt: self.createdAt, collected: self.collected, discount: self.discount, id: self.requireID(), info: self.info, percentagePaid: self.percentagePaid, planID: self.$plan.id, stripedID: self.stripeID, subtotal: self.subtotal, tax: self.tax, title: self.title, total: self.total, updatedAt: self.updatedAt)
    }
}

extension Sequence where Element: Plan.Financial {
    /// Convert each user in the collection to a public representation object.
    public func objectData() throws -> [Element.ObjectData] {
        return try self.map { try $0.objectData() }
    }
}
