//
//  DateTimeView.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/29/25.
//

import SwiftUI

struct DateTimeView: View {
    @ObservedObject var viewModel: DateFieldViewModel

    @State private var isSheetPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.field.title)
                .font(.headline)
            HStack {
                Text(viewModel.formattedValue)
                Spacer()
                Image(systemName: "calendar")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .onTapGesture {
                isSheetPresented.toggle()
            }
        }
        .padding()
        .sheet(isPresented: $isSheetPresented) {
            DatePicker("", selection: $viewModel.dateValue, displayedComponents: viewModel.displayedComponents)
                .labelsHidden()
                .datePickerStyle(.wheel)
                .presentationDetents([.fraction(0.25)])
        }
    }
}

#Preview {
    DateTimeView(viewModel: DateFieldViewModel())
}
