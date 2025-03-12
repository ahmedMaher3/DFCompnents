//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//
import SwiftUI

struct FooterComponentView: View {
    @StateObject var viewModel: FooterComponentViewModel
    @State private var showPopover = false

    init(viewModel: FooterComponentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)

    }

    var body: some View {
        renderFooter(fieldEntity: viewModel.fieldEntity, for: viewModel.interactiveProperties)
            .padding(4)
    }

    /// FooterView
    @ViewBuilder
    private func renderFooter(fieldEntity: FieldEntity, for interactiveProperties: InteractiveField?) -> some View {

        switch fieldEntity {
            case .page((_, _)): EmptyView()
            case .section((_, _)): EmptyView()
            case .radio((_, let radioViewModel)): EmptyView()
            case .textBox((_, let textBoxViewModel)): EmptyView()
            case .number((let baseField, let numberViewModel)):
                if let interactiveProperties = interactiveProperties {
                    VStack {
                        HStack(alignment: .center, spacing: 4) {
                            ZStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 16))
                                    .offset(y: -6)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        showPopover.toggle()
                                    }
                                    .popover(isPresented: $showPopover,
                                             attachmentAnchor: .point(.center),
                                             arrowEdge: .top,
                                             content: {
                                        ZStack {
                                            Color.primaryBlue 
                                                .clipShape(RoundedRectangle(cornerRadius: 12))

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Your Minimum Digit Length is \(numberViewModel.numberFieldModel.minimumDigits ?? 0)")
                                                Text("and Your Maximum Digit Length is \(numberViewModel.numberFieldModel.maximumDigits ?? 0)")
                                            }
                                            .font(.system(size: 13))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding()
                                        }
                                        .presentationCompactAdaptation(.popover)
                                    })
                            }
                            Text("\(numberViewModel.characterCount)/\(numberViewModel.numberFieldModel.maximumDigits ?? 0)")
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .offset(y: -6) 
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 0)
                        .padding(.trailing, 2)

                        if interactiveProperties.addNote || interactiveProperties.addAttachment {
                            HStack {
                                if interactiveProperties.addNote {
                                    Text("Note")
                                }
                                if interactiveProperties.addAttachment {
                                    Text("|| Attachment")
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }

                } else {
                    EmptyView()
                }
        }
    }
}
struct TooltipView: View {
    var minDigits: Int
    var maxDigits: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your Minimum Digit Length is \(minDigits) and")
            Text("Your Maximum Digit Length is \(maxDigits)")
        }
        .font(.system(size: 13))
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue) // Set your primaryBlue color here
                .overlay(
                    Triangle()
                        .fill(Color.blue) // Arrow color same as background
                        .frame(width: 20, height: 10)
                        .offset(y: -10), alignment: .top
                )
        )
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
