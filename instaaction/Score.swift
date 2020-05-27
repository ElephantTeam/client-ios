//
//  Score.swift
//  instaaction
//
//  Created by Marcin Mucha on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation

struct Score: Identifiable, Decodable {
    let id: UUID
    let userName: String
    let points: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case userName = "name"
        case points = "score"
    }
}
