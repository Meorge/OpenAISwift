//
//  Edits.swift
//  
//
//  Created by Malcolm Anderson on 9/30/22.
//

import Foundation

struct EditRequest : Encodable {
    var model: String
    var input: String
    var instruction: String
    var n: Int
    var temperature: Double
    var top_p: Double
}

struct EditResponse : Decodable {
    var created: Int
    var choices: [EditChoice]
    var usage: UsageResponse
}

struct EditChoice : Decodable {
    var text: String
    var index: Int
}
