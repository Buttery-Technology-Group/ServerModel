//
//  Project+ButteryProfile.swift
//  ButteryDatabase
//
//  Created by Jonathan Holland on 7/24/22.
//

import Fluent
import Foundation

extension Project {
    public final class ButteryProfile: Fields {
        /// Additional images or files needed for the project such as additional icons, graphics, etc.
        @OptionalField(key: "additions")                                                public var additions:              [CustomOption]?
        /// What type of navigation for the app.
        @OptionalField(key: "appNavigation")                                            public var appNavigation:          SelectionOption?
        @OptionalField(key: "customColors")                                             public var customColors:           [CustomOption]?
        /// The font to use in the app
        ///
        /// 0: system defaults, 1: custom, 2: pick for me
        @OptionalField(key: "customFont")                                               public var customFont:             Data?
        /// The setting for dark mode support
        ///
        /// 0: only light mode, 1: dark mode support, 2: dark mode only
        @OptionalField(key: "darkMode")                                                 public var darkMode:               InterfaceAppearance?
        @OptionalField(key: "features")                                                 public var features:               [SelectionOption]?
        @OptionalField(key: "font")                                                     public var font:                   FontType?
        @OptionalField(key: "generalCategory")                                          public var generalCategory:        GeneralCategory?
        @OptionalField(key: "importantFeature")                                         public var importantFeature:       ImportantFeature?
        @OptionalField(key: "interfaceStyle")                                           public var interfaceStyle:         SelectionOption?
        @OptionalField(key: "platforms")                                                public var platforms:              [SelectionOption]?

        public init() {}
        
        public init(data: ButteryProfileData?) {
            if let data = data {
                self.additions = data.additions
                self.appNavigation = data.appNavigation
                self.customColors = data.customColors
                self.customFont = data.customFont
                self.darkMode = data.darkMode
                self.features = data.features
                self.font = data.font
                self.generalCategory = data.generalCategory
                self.importantFeature = data.importantFeature
                self.interfaceStyle = data.interfaceStyle
                self.platforms = data.platforms
            }
        }
        
        // MARK: Methods
        public func objectData() -> ButteryProfileData {
            return ButteryProfileData(additions: self.additions, appNavigation: self.appNavigation, customColors: self.customColors, customFont: self.customFont, darkMode: self.darkMode, features: self.features, font: self.font, generalCategory: self.generalCategory, importantFeature: self.importantFeature, interfaceStyle: self.interfaceStyle, platforms: self.platforms)
        }
    }
}
