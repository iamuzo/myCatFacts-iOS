//
//  CatFact.swift
//  myCatFacts
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

struct TopLevelGETObject: Decodable {
    let facts: [CatFact]
}

struct CatFact: Codable {
    let id: Int?
    let details: String
}

struct TopLevelPOSTObject: Encodable {
    let fact: CatFact
}
