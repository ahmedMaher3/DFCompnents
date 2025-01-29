//
//  RadioButtons.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtons: View {
    @ObservedObject var radioButtonVM: RadioButtonViewModel
    let questions: [String]
    
    var body: some View {
        ScrollView {  // Make the content scrollable
            VStack(alignment: .leading, spacing: 20) {
                ForEach(questions.indices, id: \.self) { index in
                    let questionID = "question\(index)"
                    VStack(alignment: .leading) {
                        Text(questions[index])
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        ForEach(RadioButtonModel.elementsRadioButton) { item in
                            RadioButtonView(radioButtonState: radioButtonVM, item: item, questionID: questionID)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    RadioButtons(
        radioButtonVM: RadioButtonViewModel(),
        questions: [
            "What's your fav color ahmed ?",
            "What's your fav hassan ?",
            "What's your fav nasr ?"
        ]
    )
}
