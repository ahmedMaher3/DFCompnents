//
//  DefaultAnswer.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

struct DefaultAnswer: Codable {
    let value, otherAnswer, type, note: String?
    let score: Int?
    let attachments: [String]?
}

// MARK: - Answer Protocols
protocol Answer: Codable {
    var note: String? { get }
    var attachments: [AnyDecodable]? { get }
}

protocol TextAnswer: Answer {
    var value: String? { get }
}

protocol NumberAnswer: Answer {
    var value: Double? { get }
}

protocol MultiChoiceAnswer: Answer {
    var value: [String]? { get }
    var otherAnswer: String? { get }
}

// MARK: - Base Answer Types
struct BaseAnswer: Answer {
    let note: String?
    let attachments: [AnyDecodable]?
    
    init(note: String? = nil, attachments: [Any]? = nil) {
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct BaseAnswerText: TextAnswer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: String?
    
    init(value: String, note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct BaseAnswerNumber: NumberAnswer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: Double?
    
    init(value: Double, note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

// MARK: - Specific Answer Types
struct TextboxAnswer: TextAnswer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: String?
    let prefix: String?
    let suffix: String?
    
    init(value: String, prefix: String, suffix: String, note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.prefix = prefix
        self.suffix = suffix
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct TextAreaAnswer: TextAnswer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: String?
    let htmlValue: String?
    
    init(value: String, htmlValue: String, note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.htmlValue = htmlValue
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct DateTimeAnswer: Answer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: [String]?
    
    init(value: [String], note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct LocationAnswer: Answer {
    let note: String?
    let attachments: [AnyDecodable]?
//    let value: [Place]?
    
    init(/*value: [Place],*/ note: String? = nil, attachments: [Any]? = nil) {
//        self.value = value
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct SliderAnswer: Answer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: [Double]?
    
    init(value: [Double], note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

struct BaseAnswerMCQ: MultiChoiceAnswer {
    let note: String?
    let attachments: [AnyDecodable]?
    let value: [String]?
    let otherAnswer: String?
    
    init(value: [String], otherAnswer: String? = nil, note: String? = nil, attachments: [Any]? = nil) {
        self.value = value
        self.otherAnswer = otherAnswer
        self.note = note
        self.attachments = attachments?.map(AnyDecodable.init)
    }
}

// MARK: - Helper for Any type encoding/decoding
struct AnyDecodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyDecodable].self) {
            value = array.map(\.value)
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            value = dictionary.mapValues(\.value)
        } else {
            value = NSNull()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [Any]:
            try container.encode(array.map(AnyDecodable.init))
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues(AnyDecodable.init))
        default:
            try container.encodeNil()
        }
    }
}
