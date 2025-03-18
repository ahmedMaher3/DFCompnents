//
//  DFComponentsApp.swift
//  DFComponents
//
//  Created by ahmed maher on 29/01/2025.
//

import SwiftUI

@main
struct DFComponentsApp: App {
    @State var appearanceManager = AppearanceManager()

    @State private var currentLocale: Locale = {
        if let savedLocale = UserDefaults.standard.string(forKey: "selectedLocale") {
            return Locale(identifier: savedLocale)
        }
        return .current
    }()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(appearanceManager)
                .environment(\.locale, currentLocale)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
            }
        }
    }
}
