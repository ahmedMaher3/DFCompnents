//
//  DateRangePickerView.swift
//  ViewBuilderDynamiForm
//
//  Created by Eslam on 03/02/2025.
//

import SwiftUI

struct DateRangePickerView: View {
    @State private var dates: Set<DateComponents> = []
    var body: some View {
        MultiDatePicker("Dates Available", selection: $dates)
    }
}

#Preview {
    DateRangePickerView()
}
