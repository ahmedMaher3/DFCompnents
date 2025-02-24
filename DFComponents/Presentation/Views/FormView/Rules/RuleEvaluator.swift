//
//  RuleEvaluator.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//

protocol RuleEvaluator {
    mutating func getAffectedRules(forControlId controlId: String)
    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction])
    func validateCondition(_ condition: IfCondition) -> Bool
}
