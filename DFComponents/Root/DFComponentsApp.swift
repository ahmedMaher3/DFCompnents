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
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
            // test commit/push
        }
    }
}
