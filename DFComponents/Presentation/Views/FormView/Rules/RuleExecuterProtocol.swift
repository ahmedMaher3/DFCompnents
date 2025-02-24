//
//  RuleExecuterProtocol.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//


protocol RuleExecuterProtocol {
    func executeActions(valid: Bool, doActions: [DoAction], controls: inout [Field])
}
