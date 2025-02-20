//
//  RuleExecuterProtocol.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/20/25.
//


protocol RuleExecuterProtocol {
    func executeActions(valid: Bool, doActions: [DoAction], controls: inout [Field])
}

protocol RuleEvaluator {
    func getRules(forControlId controlId: String, controls: [Field]) -> [String]
    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction])
    func validateCondition(_ condition: IfCondition) -> Bool
}

protocol DefaultVal {
    
}

struct RuleImp: RuleEvaluator, RuleExecuterProtocol {
    
    var controls: [Field]
    
    init(controls: [Field]) {
        self.controls = controls
    }

    func getRules(forControlId controlId: String, controls: [Field]) -> [String] {
        guard let control = controls.first(where: { $0.id == controlId }) else {
            return []
        }
        return control.rules?.effectIn ?? [] // get affected rules ids
    }

    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction]) {
        for rule in rules {
            guard !rule.disabled else { continue } // Skip disabled rules
            
            let areConditionsValid: Bool
            switch rule.operation {
            case "All":
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

        var defVal: DefaultVal?
        var conditionIsValid: Bool = false
        
        if condition.target == "Value" { // target
            let checkedFieldID = condition.fieldId // fieldId
            if let control = controls.first(where: {
                $0.id == checkedFieldID
            }) {
                // get value from control
                defVal = control.properties.defaultAnswer as? DefaultVal
            }
        }
        
    //    switch condition.fieldState {
    //
    //    case "Include", "NotInclude":
    //        handleIncludeState(
    //            value, valueValidator, valid: &conditionIsValid,
    //            include: condition.fieldState == "Include")
    //    default:
    //        return false
    //    }
        
        return conditionIsValid
    }

    func getItemValue(control: Field) -> DefaultVal? {
        switch control.type {
        case .Radio:
    //        return control.properties.defaultAnswer as! RadioAnswer
            return nil
        default:
            return nil
        }
    }

    func handleIncludeState(
        _ value: [String]?, _ valueValidator: [String]?, valid: inout Bool,
        include: Bool
    ) {
        guard let validatorValue = valueValidator, let itemValue = value else {
            return
        }
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
        guard valid else { return }
        
        for action in doActions {
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