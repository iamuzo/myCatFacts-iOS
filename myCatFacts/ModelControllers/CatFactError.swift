//
//  CatFactError.swift
//  myCatFacts
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

enum CatFactError: LocalizedError {
    case invalidURL
    case noData
    case thrownError(Error)
}
