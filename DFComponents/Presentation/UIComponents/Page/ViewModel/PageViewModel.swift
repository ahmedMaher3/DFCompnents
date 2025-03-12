//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var controls: [FieldEntity] {
        didSet {
            print("Page controls updated:- \(controls)")
        }
    }
    
    init(controls: [FieldEntity]) {
        self.controls = controls
    }
}
