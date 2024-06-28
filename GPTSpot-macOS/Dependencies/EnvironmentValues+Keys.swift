//
//  EnvironmentValues+Keys.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import SwiftUI
import GPTSpot_Common

public struct ContainerKey: EnvironmentKey {
    public static var defaultValue: Container = Container.shared
}

public struct TemplateServiceKey: EnvironmentKey {
    public static let defaultValue: TemplateService = Container.shared.resolve(TemplateService.self)
}

public struct ChatMessageServiceKey: EnvironmentKey {
    public static let defaultValue: ChatMessageService = Container.shared.resolve(ChatMessageService.self)
}

public struct OpenAIServiceKey: EnvironmentKey {
    public static let defaultValue: OpenAIService = Container.shared.resolve(OpenAIService.self)
}

public struct ChatViewServiceKey: EnvironmentKey {
    public static let defaultValue: ChatViewService = Container.shared.resolve(ChatViewService.self)
}

extension EnvironmentValues {
    public var container: Container {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }

    public var templateService: TemplateService {
        get { self[TemplateServiceKey.self] }
        set { self[TemplateServiceKey.self] = newValue }
    }

    public var chatMessageService: ChatMessageService {
        get { self[ChatMessageServiceKey.self] }
        set { self[ChatMessageServiceKey.self] = newValue }
    }

    public var openAIService: OpenAIService {
        get { self[OpenAIServiceKey.self] }
        set { self[OpenAIServiceKey.self] = newValue }
    }

    public var chatViewService: ChatViewService {
        get { self[ChatViewServiceKey.self] }
        set { self[ChatViewServiceKey.self] = newValue }
    }
}
