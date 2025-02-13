//
//  RouterManager.swift
//  iOSChallenge
//
//  Created by ahmed maher on 11/02/2025.
//

import Foundation
import SwiftUI

enum RouteType: Hashable {
    case search
    case details
}

protocol Routable {
    var path: NavigationPath { get set }
    func push(to route: RouteType)
    func goBack()
    func reset()
    func goToRoot()
    func navigateToSpecific(route: RouteType)
    @ViewBuilder func destination(for route: RouteType)
}



class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(to route: RouteType) {
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

    func navigateToSpecific(route: RouteType) {
           reset()
           push(to: route)
       }

    @ViewBuilder
       func destination(for routeType: RouteType) -> some View {
           switch routeType {
           case .search:
               SplashView()
           case .details:
               SplashView()
           }
       }
}

