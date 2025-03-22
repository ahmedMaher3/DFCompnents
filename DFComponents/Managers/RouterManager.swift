//
//  RouterManager.swift
//  iOSChallenge
//
//  Created by ahmed maher on 11/02/2025.
//

import Foundation
import SwiftUI

enum RouteType: Hashable, Identifiable {
    case search
    case details
    case welcomeView(viewModel: WelcomeViewModel)
    var id: Self { self }
    
    static func == (lhs: RouteType, rhs: RouteType) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search), (.details, .details):
            return true
        case let (.welcomeView(lhsViewModel), .welcomeView(rhsViewModel)):
            return lhsViewModel.id == rhsViewModel.id // Compare IDs
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .search:
            hasher.combine("search")
        case .details:
            hasher.combine("details")
        case .welcomeView(let viewModel):
            hasher.combine("welcomeView")
            hasher.combine(viewModel.id) // Use a unique identifier
        }
    }

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
    @Published var presentedRoute: RouteType? = nil // Track presented screen

    func push(to route: RouteType) {
        path.append(route)
    }
    
    func present(_ route: RouteType) {
        presentedRoute = route
    }

    func dismiss() {
        presentedRoute = nil
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
           case .welcomeView(let viewModel):
               WelcomeView(viewModel: viewModel)
           }
       }
}

