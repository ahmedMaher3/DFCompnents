//
//  AppearanceManager.swift
//  DFComponents
//
//  Created by mac on 2/13/25.
//

import SwiftUI

enum Appearance: LocalizedStringKey, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: String { UUID().uuidString }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let store: UserDefaults

    init(_ key: String, defaultValue: T, store: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = store
    }

    var wrappedValue: T {
        get {
            store.object(forKey: key) as? T ?? defaultValue
        }
        set {
            store.set(newValue, forKey: key)
        }
    }
}

@Observable
class AppearanceManager {
    @UserDefault("userInterfaceStyle", defaultValue: 0)
    //    @ObservableUserDefault(.init(key: "userInterfaceStyle", store: .standard))
    @ObservationIgnored
    var userInterfaceStyle: Int?
    
    var selectedAppearance: Appearance = .system
    
    // Rest of the codes...
    
    func initAppearanceStyle() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch userInterfaceStyle {
                case 0:
                    window.overrideUserInterfaceStyle = .unspecified
                case 1:
                    window.overrideUserInterfaceStyle = .light
                case 2:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
    
    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedAppearance {
                case .system:
                    userInterfaceStyle = 0
                    window.overrideUserInterfaceStyle = .unspecified
                case .light:
                    userInterfaceStyle = 1
                    window.overrideUserInterfaceStyle = .light
                case .dark:
                    userInterfaceStyle = 2
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
    func setInitialSelectedAppearance() {
        switch userInterfaceStyle {
        case 0:
            selectedAppearance = .system
        case 1:
            selectedAppearance = .light
        case 2:
            selectedAppearance = .dark
        default:
            selectedAppearance = .system
        }
    }
    
}
