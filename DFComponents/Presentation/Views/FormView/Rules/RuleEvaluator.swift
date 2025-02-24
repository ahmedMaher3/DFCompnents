protocol RuleEvaluator {
    func getRules(forControlId controlId: String, controls: [Field]) -> [String]
    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction])
    func validateCondition(_ condition: IfCondition) -> Bool
}
