//
//  StringExtension.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}

extension String {
func replaceValidationWith(_ value: Any?) -> String {
        return self.replacingOccurrences(of: "{0}", with: "\(value!)")
    }
}
