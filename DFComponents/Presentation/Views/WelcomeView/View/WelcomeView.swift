//
//  WelcomeView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            if let data = viewModel.welcomeData {
                // Logo
                AsyncImage(url: URL(string: data.logoURL)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 40)
                .padding(.bottom, 16)
                
                // Title
                Text(data.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#173E67"))

                // Subtitle
                Text(data.subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#173E67"))
                    .padding(.top, 6)

                // Questions Count
                if data.showQuestionCount {
                    Text("\(data.questionCount) Questions")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#9EB3C2"))
                        .padding(.top, 16)
                }
                
                Spacer()
                
                // Start Button
                Button(action: {
                    print("Start button tapped")
                }) {
                    Text(data.buttonText)
                        .font(.system(size: 18, weight: .bold))
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#5989EF"))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .padding(.horizontal, 24)
                }
            } else {
                ProgressView() // Show loading indicator
            }
        }
        .padding(.bottom, 32)
        .onAppear {
            viewModel.fetchWelcomeData()
        }
    }
}

#Preview {
    WelcomeView()
}
