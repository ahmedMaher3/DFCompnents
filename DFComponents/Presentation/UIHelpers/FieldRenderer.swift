//
//  FileRenderable.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

import SwiftUI

struct FieldRenderer: View {
   let field: FieldEntity

   var body: some View {
       switch field {
           case .radio((_, let viewModel)):
               BaseFieldContainerView(fieldEntity: field) {
                   RadioButtonView(radioButtonVM: viewModel)
               }
               .opacity(viewModel.control.hidden ? 0 : 1)

           case .textBox((_, let viewModel)):
               BaseFieldContainerView(fieldEntity: field) {
                   TextBoxComponent(viewModel: viewModel)
               }
               .opacity(viewModel.control.hidden ? 0 : 1)

           case .number((_, let viewModel)):
               BaseFieldContainerView(fieldEntity: field) {
                   NumberFieldComponent(viewModel: viewModel)
               }

           case .section((_, let viewModel)):
               SectionView(
                   sectionViewModel: viewModel,
                   fields: viewModel.controls,
                   isExpanded: viewModel.sectionField.isExpandedStatus
               )
               .onReceive(viewModel.objectWillChange) { _ in
                   print("Updated Values: \(viewModel.controls)")
               }

           case .page:
               EmptyView()
       }
   }
}
