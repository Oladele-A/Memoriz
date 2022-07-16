//
//  RandomQuoteResponse.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/15/22.
//

import Foundation

struct RandomQuoteResponse: Codable{
    let quote: String
    let author: String
    let htmlFormat: String
    
    
    enum CodingKeys: String, CodingKey{
        case quote = "q"
        case author = "a"
        case htmlFormat = "h"
    }
}
