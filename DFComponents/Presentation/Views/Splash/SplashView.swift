//
//  SplashView.swift
//  DFComponents
//
//  Created by ahmed maher .
//

import SwiftUI
import Alamofire

struct SplashView: View {
    @State private var isActive = false
    @StateObject  var formViewModel = FormViewModel()
    @StateObject  var stepProgressViewModel = StepProgressViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()
    @State private var currentLocale: Locale = .current
    @State private var showingAppearanceSheet = false
    @State private var currentPage: Int = 0

    var body: some View {
        ZStack {
            if isActive {
                FormBuilderView(
                    viewModel: formViewModel,
                    stepProgressViewModel: stepProgressViewModel,
                    styleManagerVM: styleManagerVM,
                    currentLocale: $currentLocale,
                    showingAppearanceSheet: $showingAppearanceSheet,
                    currentPage: $currentPage)
                .render()
                //MARK: - Composite Pattern
                //                   FormBuilderWrapperView()
            } else {
                SplashContentView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Splash Content
struct SplashContentView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
    }
}
//#Preview {
//    SplashView()
//}
