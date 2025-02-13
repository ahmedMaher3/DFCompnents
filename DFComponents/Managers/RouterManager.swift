//
//  RouterManager.swift
//  iOSChallenge
//
//  Created by ahmed maher on 11/02/2025.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case search
    case details
}

class Router: ObservableObject {
    @Published var path = NavigationPath()  // Stores the navigation stack

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func reset() {
        path = NavigationPath()
    }

    @ViewBuilder
       func destination(for route: Route) -> some View {
           switch route {
           case .search:
               SplashView()
           case .details:
               SplashView()
           }
       }

}

