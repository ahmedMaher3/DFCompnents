//
//  FormMainDTO.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//

import Foundation

// MARK: - Common Protocol
protocol Control: Codable {
    var id: String { get }
    var type: String { get }
    var parentId: String { get }
    var rowIndex: Int? { get }
    var order: String { get }
    var templateQuestionId: String? { get }
    var visibilityPermissions: String? { get }
    var rules: Rules { get }
    associatedtype PropertiesType: Codable
    var properties: PropertiesType { get }
    var controlProperties: ControlProperties { get } // Composition
}

// MARK: - Common Models
struct Rules: Codable {
    let effectIn: [String]?
    let dependOn: [String]?
}

struct Localization: Codable {
    struct FieldWarning: Codable {
        let required: String?
    }

    struct Language: Codable {
        let placeholder: String?
        let label: String?
        let sublabel: String?
        let tooltip: String?
        let fieldWarning: FieldWarning?
    }

    let en: Language
    let ar: Language
}

struct Style: Codable {
    let border: String?
    let borderType: String?
    let borderColor: String?
    let backgroundColor: String?
    let textColor: String?
    let textAlign: String?
    let font: String?
    let fontSize: String?
}

struct ControlProperties: Codable {
    let required: Bool
    let readonly: Bool
    let unique: Bool?
    let placeholder: String
    let sendToBPM: Bool
    let localization: Localization
    let style: Style
    let label: String
    let sublabel: String
    let tooltip: String
    let ruleWarning: String?
    let hideIfEmptyInDetails: Bool
    let dataSourcId: String?
    let dataSource: String?
    let dataSourceObj: String?
}
