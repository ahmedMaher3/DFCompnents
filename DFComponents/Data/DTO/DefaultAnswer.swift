//
//  DefaultAnswer.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//


struct DefaultAnswer: Codable {
    let value, otherAnswer, type, note: String?
    let score: Int?
    let attachments: [String]?
}
