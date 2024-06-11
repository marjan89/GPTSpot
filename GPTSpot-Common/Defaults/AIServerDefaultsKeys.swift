//
//  AIServerDefaultsKeys.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation

public extension UserDefaults {

    enum AIServerKeys {
        public static let aiModel: String = "aiModel"
        public static let temperature: String = "temperature"
        public static let openAiKey: String = "openAiKey"
        public static let maxHistory: String = "maxHistory"
        public static let systemMessage: String = "systemMessage"
        public static let useSystemMessage: String = "useSystemMessage"
    }

    enum GeneralSettingsKeys {
        public static let loginItem: String = "loginItem"
        public static let startHidden: String = "startHidden"
        public static let hideFromDock: String = "hideFromDock"
        public static let windowed: String = "windowed"
        public static let keepOnTop: String = "keepOnTop"
    }

    enum IOSKeys {
        public static let expandedInputField: String = "expandedInputField"
    }
}
