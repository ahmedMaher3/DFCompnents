//
//  RuleFormBuilder.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//

import Foundation
/*
  - Rule Ids
  - Main Rule
 */
struct RuleImp: RuleEvaluator, RuleExecuterProtocol {

    var controls: [Field]
    let rules: [Rule]

    private var controlDictionary: [String: Field] = [:]

    init(controls: [Field], rules: [Rule]) {
        self.controls = controls
        self.rules = rules
        self.controls.forEach { control in
            self.controlDictionary[control.id ?? ""] = control
        }
    }

    mutating func handleAllRules() {
        let evaluateRules = self.evaluateRules(rules: rules)
        self.executeActions(valid: evaluateRules.valid,
                            doActions: evaluateRules.doActions,
                            controls: &controls)
    }

    mutating func getAffectedRules(forControlId controlId: String){
        guard let control = self.controlDictionary[controlId] else {
            return print("affected rules not included into control")
        }

        let affectedRuleIds = control.rules?.effectIn ?? []
        let affectedRules = rules.filter { affectedRuleIds.contains($0.id) }
        let evaluateRules = self.evaluateRules(rules: affectedRules)

        self.executeActions(valid: evaluateRules.valid,
                            doActions: evaluateRules.doActions,
                            controls: &controls)
    }

    ///evaluateRules in first time get all rules without operation || get evaluateRules through (update or edit request)
    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction]) {
        for rule in rules {
            guard !rule.disabled else { continue } // Skip disabled rules
            let areConditionsValid: Bool
            switch rule.operation {
                case "All":
                    /// All be true
                    areConditionsValid = rule.ifConditions.allSatisfy { validateCondition($0) }
                case "Any":
                    areConditionsValid = rule.ifConditions.contains { validateCondition($0) }
                default:
                    areConditionsValid = false
            }
            if areConditionsValid {
                return (true, rule.doActions)
            }
        }
        return (false, [])
    }

    func validateCondition(_ condition: IfCondition) -> Bool { // Ongoing function

        var value: [String]?
        var conditionIsValid: Bool = false

        if condition.target == "Value" { // target
            let checkedFieldID = condition.fieldId // fieldId
            guard let field = self.controlDictionary[checkedFieldID] else {
                return false
            }
            getItemValue(field, &value)
        }

        self.handleFieldState(condition, value: value, valid: &conditionIsValid)
        return conditionIsValid
    }

    func handleFieldState(_ condition: IfCondition,value: [String]?,valid: inout Bool) {
        switch condition.fieldState {
            case "Include", "NotInclude":
                handleIncludeState(
                    value, [condition.value], valid: &valid,
                    include: condition.fieldState == "Include")
            default:
               break
        }
    }
    //MARK: - <#placeholder#>
    func getItemValue(_ item: Field, _ value: inout [String]?) {

        /*
         if let val = (item.answer as? BaseAnswerNumber)?.value {
         value = getNumberValue(val: [val])
         }
         if let val = (item.answer as? SliderAnswer)?.value {
         value = getNumberValue(val: val)
         }
         if let val = (item.answer as? DateTimeAnswer)?.value {
         value = val
         }
         if let val = (item.answer as? BaseAnswerMCQ)?.value {
         value = val
         }
         if let val = (item.answer as? LocationAnswer)?.value {
         value = [val.toJSONString() ?? ""]
         }
         */
    }


    func handleIncludeState(
        _ value: [String]?, _ valueValidator: [String]?, valid: inout Bool,
        include: Bool
    ) {
        guard let validatorValue = valueValidator,
              let itemValue = value else { return }

        for value in validatorValue {
            if include {
                if itemValue.contains(where: {
                    $0.lowercased() == value.lowercased()
                }) {
                    valid = true
                }
            } else {
                if !itemValue.contains(where: { $0 == value }) {
                    valid = true
                }
            }

        }
    }
    func executeActions(valid: Bool, doActions: [DoAction], controls: inout [Field]) {
        for action in doActions {
            /// targetFieldsIds for every child control not parent control 
            for targetFieldId in action.targetFieldsIds {
                guard let targetControlIndex = controls.firstIndex(where: { $0.id == targetFieldId }) else {
                    continue
                }
                switch action.type {
                    case "Show":
                        controls[targetControlIndex].properties.hidden = valid
                    case "Hide":
                        controls[targetControlIndex].properties.hidden = !valid
                    default:
                        break
                }
            }
        }
    }
}
