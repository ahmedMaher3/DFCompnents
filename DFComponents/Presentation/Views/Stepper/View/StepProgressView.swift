//
//  StepProgressView.swift
//  CERQEL
//
//  Created by ahmed maher on 09/03/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import SwiftUI

struct StepProgressView: View {

    @ObservedObject var viewModel: StepProgressViewModel

    let blueColor = Color(.systemBlue)
    let greyColor = Color(.systemGray4)
    let progressColor = Color(.systemGreen)

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Page \(viewModel.currentPage + 1) / \(viewModel.totalPages)")
                    .font(.system(size: 20, weight: .bold))

                Text("\(viewModel.completionPercentage) % Complete")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(greyColor)

            }
            .padding(.horizontal, 16)

            StepProgressBar(progress: viewModel.progress, barColor: progressColor, backgroundColor:greyColor)

        }
    

    }
}


struct StepProgressBar: View {
    var progress: Double
    var barColor: Color = .blue
    var backgroundColor: Color = .gray

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(backgroundColor)

                // Progress bar
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(barColor)
                    .frame(width: CGFloat(progress) * geometry.size.width)
            }
        }
        .frame(height: 8)
    }
}
