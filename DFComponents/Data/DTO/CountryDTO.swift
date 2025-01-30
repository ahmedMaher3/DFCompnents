//
//  CountryDTO.swift
//  iOS Chanllenge
//
//  Created by ahmed maher on 14/12/2024.
//

import Foundation

struct CountryDTO : Codable, Identifiable,Equatable{

    var id: String { capital }
    let name: String
    let capital: String
    let flag: String?


}



