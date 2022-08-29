//
//  SelectionOption.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/16/22.
//

import Fluent
import Vapor

public final class SelectionOption: Fields {
    @Field(key: "fromPrice")            public var fromPrice:              String?
    @Field(key: "requiresCloud")        public var requiresCloud:          Bool?
    @Field(key: "title")                public var title:                  String
    @Field(key: "tooltip")              public var tooltip:                String
    
    public init() {}
    
    public init(title: String, fromPrice: String? = nil, tooltip: String, requiresCloud: Bool? = nil) {
        self.title = title
        self.fromPrice = fromPrice
        self.tooltip = tooltip
        self.requiresCloud = requiresCloud
    }
    
    convenience public init(feature: FeatureTitle, fromPrice: String, tooltip: String, requiresCloud: Bool = false) {
        self.init(title: feature.rawValue, fromPrice: fromPrice, tooltip: tooltip, requiresCloud: requiresCloud)
    }
    
    convenience public init(platform: Platform, fromPrice: String, tooltip: String) {
        self.init(title: platform.rawValue, fromPrice: fromPrice, tooltip: tooltip)
    }
}

// MARK: - Platforms
extension SelectionOption {
    public static let android = SelectionOption(platform: .android, fromPrice: "18k", tooltip: "Apps for general Android operating system")
    public static let iOS = SelectionOption(platform: .iOS, fromPrice: "18k", tooltip: "Apps for iPhone and iPad")
    public static let macOS = SelectionOption(platform: .macOS, fromPrice: "20k", tooltip: "Apps for Mac, such as MacBooks.")
    public static let watchOS = SelectionOption(platform: .watchOS, fromPrice: "14k", tooltip: "Apps for Apple Watch")
    public static let web = SelectionOption(platform: .web, fromPrice: "16k", tooltip: "Apps designed for the web")
    public static let windows = SelectionOption(platform: .windows, fromPrice: "22k", tooltip: "Apps for general Windows operating system")
}

// MARK: - Cloud
extension SelectionOption {
    public static let none = SelectionOption(title: "None", fromPrice: "0", tooltip: "No cloud features/functionality will be used")
    public static let buttery = SelectionOption(title: "Buttery", fromPrice: "2k", tooltip: "Use Buttery's always-on and revolutionary cloud system")
    public static let firebase = SelectionOption(title: "Firebase", fromPrice: "3k", tooltip: "Use Google's Firebase system with Firecloud's no-SQL document-based system.")
    public static let iCloud = SelectionOption(title: "iCloud", fromPrice: "2k", tooltip: "Use Apple's iCloud with the ability to sync local and remote data in their containers.")
    public static let mongoDB = SelectionOption(title: "MongoDB", fromPrice: "3k", tooltip: "Use MongoDB's cloud no-SQL system for cloud storage.")
    public static let myOwn = SelectionOption(title: "I have my own", fromPrice: "<1k", tooltip: "Integrate your cloud servers into the application.")
}

// MARK: - Features
extension SelectionOption {
    public static let analytics = SelectionOption(feature: .analytics, fromPrice: "3k", tooltip: "Get data on how your app is used through Google, Buttery or another company. A privacy disclosure is recommended. This feature requires a backend server to function and on-going maintenance, not necessarily through us.", requiresCloud: true)
    public static let blog = SelectionOption(feature: .blog, fromPrice: "2k", tooltip: "Communicate with your audience and fans through posts and stories right in your app. This feature will need the storage option and cloud.", requiresCloud: true)
    public static let booking = SelectionOption(feature: .booking, fromPrice: "7k", tooltip: "Allow your customers to easily schedule and book your services. This feature will require a backend server to function and on-going maintenance, not necessarily throught us", requiresCloud: true)
    public static let calendar = SelectionOption(feature: .calendar, fromPrice: "<1k", tooltip: "Allow customers to interact with and manage calendar. We can use built-in calendar views or customize it for you.")
    public static let forum = SelectionOption(feature: .forum, fromPrice: "5k", tooltip: "Allow your customers to communicate with each other on topics related to your brand. This feature will need a unified cloud experience.", requiresCloud: true)
    public static let graphics = SelectionOption(feature: .grphics, fromPrice: "3k", tooltip: "Customize the graphics in your application to suite your specific brand.")
    public static let maps = SelectionOption(feature: .maps, fromPrice: "2k", tooltip: "Allow your customers to view important locations on Apple Maps or get directions to your place of business.")
    public static let media = SelectionOption(feature: .media, fromPrice: "5k", tooltip: "Allow your customers to view pictures and videos you provide. This feature will require storage.")
    public static let messaging = SelectionOption(feature: .messaging, fromPrice: "8k", tooltip: "Allow your customers to communicate with you or others with direct messaging.")
    public static let purchasing = SelectionOption(feature: .purchasing, fromPrice: "8k", tooltip: "Allow your customers to easily purchase your products. This feature will require a backend server to function and on-going maintenance, not necessarily through us", requiresCloud: true)
    public static let search = SelectionOption(feature: .search, fromPrice: "1k", tooltip: "Allow your customers to search for things to find what they need/want quicker.")
    public static let sharing = SelectionOption(feature: .sharing, fromPrice: "2k", tooltip: "Allow your customers to share items they love with others.")
    public static let signUp = SelectionOption(feature: .signup, fromPrice: "2k", tooltip: "Allow your customers to sign up to your services.")
    public static let socialLogin = SelectionOption(feature: .socialLogin, fromPrice: "2k", tooltip: "Allow your customers to easily sign up for your services using social plugins, such as Google or Apple.")
    public static let storage = SelectionOption(feature: .storage, fromPrice: "2k", tooltip: "Allow your customers to store files and/or media. This feature may require a backend server (depending on the cloud service you select) to function and on-going maintenance, not necessarily through us.")
    public static let streaming = SelectionOption(feature: .streaming, fromPrice: "12k", tooltip: "Allow your customers to live stream on your app. This feature requires a backend server to function and on-going maintenance, not necessarily through us.", requiresCloud: true)
    public static let userProfile = SelectionOption(feature: .userProfile, fromPrice: "4k", tooltip: "Allow your customers to create custom profiles for your service. This feature will need a unified cloud experience.", requiresCloud: true)
    public static let videoCalls = SelectionOption(feature: .videoCalls, fromPrice: "16k", tooltip: "Allow your customers to communicate through video calls. This feature requires a backend server to function and on-going maintenance, not necessarily through us.", requiresCloud: true)
}

// MARK: - App Navigation
extension SelectionOption {
    public static let singlePage = SelectionOption(title: "Single-page", tooltip: "Navigation through a single page. An example of single-page navigation would be Apple Messages or Settings on iOS devices.")
    public static let multiTab = SelectionOption(title: "Multi-tab", tooltip: "Navigation through tabs. An example of multi-tab navigation would be Apple Music on iOS devices.")
    public static let sidebar = SelectionOption(title: "Sidebar", tooltip: "Navigation through a sidebar. An example would be Mail on macOS or on iPad.")
    public static let pickForMe = SelectionOption(title: "Pick for me", tooltip: "Allow Buttery Design to analyze the features and functionality and pick one that would be best suited for your app.")
}

// MARK: - App Interface
extension SelectionOption {
    public static let glassmorphism = SelectionOption(title: "Glassmorphism", fromPrice: "4k", tooltip: "")
    public static let neomorphism = SelectionOption(title: "Neomorphism", fromPrice: "2k", tooltip: "")
}
