//
//  HeaderComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI
/*
 struct HeaderComponentView<BaseComponentProperties: BasePropertiesProtocol>: View {
 /// BaseProperties
 @ObservedObject var viewModel: HeaderComponentViewModel<BaseComponentProperties>

 init(viewModel: HeaderComponentViewModel<BaseComponentProperties>) {
 self.viewModel = viewModel
 }

 var body: some View {
 HStack(alignment: .firstTextBaseline, spacing: 4) {
 if let label = viewModel.baseProperties.label {
 Text(label)
 .font(.headline)
 .foregroundColor(.primary)
 }
 if let subLabel = viewModel.baseProperties.subLabel {
 Text(subLabel)
 .font(.subheadline)
 .foregroundStyle(.red)
 }
 if let tooltip = viewModel.baseProperties.tooltip {
 HStack {
 Text("ⓘ")
 .font(.system(size: 18))
 .foregroundStyle(.gray)

 Text(tooltip)
 .font(.system(size: 20))
 .foregroundStyle(.gray)
 .offset(y: 5) // Moves only the tooltip text downward
 }
 }
 }
 .frame(maxWidth: .infinity, alignment: .topLeading)
 }

 private var labelAlignment: Alignment {
 switch viewModel.baseProperties.labelPosition?.lowercased() {
 case "left": return .leading
 case "right": return .trailing
 default: return .center
 }
 }
 }
 */
struct HeaderComponentView<ContentHeader: View>: View {
    @ObservedObject var viewModel: HeaderComponentViewModel
    let content: () -> ContentHeader

    init(viewModel: HeaderComponentViewModel, @ViewBuilder content: @escaping () -> ContentHeader) {
        self.viewModel = viewModel
        self.content = content
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
