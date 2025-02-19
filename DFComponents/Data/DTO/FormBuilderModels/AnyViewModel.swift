//
//  AnyViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//

import Foundation

class AnyViewModel {
    private let _as: (Any.Type) -> Any?

    init<T: AnyObject>(_ viewModel: T) {
        self._as = { $0 is T.Type ? viewModel : nil }
    }

    func `as`<T>(_ type: T.Type) -> T? {
        _as(type) as? T
    }
}
