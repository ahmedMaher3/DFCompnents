//
//  BaseFieldContainerView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct BaseFieldContainerView: View {
  //  let control: () -> Control
    let field: FieldRenderable
   // let fieldEntity: FieldEntity

    init(
        field: FieldRenderable )
        //fieldEntity: FieldEntity,
        //@ViewBuilder controlType: @escaping () -> Control)
    {
            self.field = field
          // self.control = controlType
       // self.fieldEntity = fieldEntity
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
           BaseHeaderControlView(viewModel: BaseHeaderViewModel(field: field))

            /// Control with overlay for warnings
            field.render()
//

           // Footer View - Aligned to Control
//            BaseFooterControlView(viewModel: BaseFooterViewModel(field: field))
//                .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
//                .padding(.leading, 0) // Adjust leading padding as needed to match the control

            /// Warning View
            WarningCardView(message: field.errorMessage ?? "" )
                .opacity(field.errorMessage == nil ? 0 : 1)
        }
        .padding(6)
       .background(field.errorMessage == nil || field.errorMessage == "" ? Color.clear : Color.red.opacity(0.05))
        .cornerRadius(8)
    }
}

