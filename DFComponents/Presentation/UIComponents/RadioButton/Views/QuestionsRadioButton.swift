//
//  QuestionsRadioButton.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct QuestionsRadioButton: View {
    @ObservedObject var radioButtonVM: RadioButtonViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(radioButtonVM.questions.indices, id: \.self) { index in
                    let questionID = "question\(index)"
                    VStack(alignment: .leading) {
                        Text(radioButtonVM.questions[index])
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        RadioButtonView(radioButtonState: radioButtonVM,
                                        questionID: questionID)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(16)
        }
    }
}
#Preview {
    QuestionsRadioButton(radioButtonVM: RadioButtonViewModel())
}
