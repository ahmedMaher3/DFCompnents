//
//  MaskedTextField.swift
//  DFComponents
//
//  Created by hassan elshaer on 05/02/2025.
//

import SwiftUI

struct MaskTextField: UIViewRepresentable {
    @Binding var text: String
    var mask: String

    class Coordinator: NSObject, UITextFieldDelegate, AKMaskFieldDelegate {
        var parent: MaskTextField

        init(parent: MaskTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Update the text binding with the current value
            parent.text = textField.text ?? ""
            return true
        }

        func handleMask(_ mask: String) {
            if !mask.isEmpty {
                // Create the mask expression for AKMaskField
                let maskExpression = mask.replacingOccurrences(of: "9", with: "d").replacingOccurrences(of: "*", with: ".")
                let maskTemplate = mask.replacingOccurrences(of: "9", with: "_").replacingOccurrences(of: "a", with: "_").replacingOccurrences(of: "*", with: "_")
                let maskPlaceholder = maskTemplate.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")

                let specialChars: [Character] = ["d", "a", "."]
                var newMask = ""

                for char in maskExpression {
                    if specialChars.contains(char) {
                        newMask.append("{\(char)}")
                    } else {
                        newMask.append(char)
                    }
                }

                // Set the mask on the TextField
                let valueTF = parent.textField
                valueTF.setMask(newMask, withMaskTemplate: "_")
                valueTF.placeholder = maskPlaceholder
                valueTF.maskDelegate = self
                valueTF.refreshMask()
            }
        }
    }

    var textField = AKMaskField()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> AKMaskField {
        // Set the mask delegate
        textField.maskDelegate = context.coordinator
        textField.refreshMask()
        return textField
    }

    func updateUIView(_ uiView: AKMaskField, context: Context) {
        // When the mask or text changes, update the AKMaskField accordingly
        context.coordinator.handleMask(mask)
    }
}
