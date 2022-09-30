//
//  RequestUtilities.swift
//  
//
//  Created by Malcolm Anderson on 9/30/22.
//

import Foundation

struct UsageResponse : Decodable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens: Int
}
