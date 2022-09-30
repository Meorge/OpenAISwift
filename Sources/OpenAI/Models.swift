//
//  Models.swift
//  
//
//  Created by Malcolm Anderson on 9/30/22.
//

import Foundation

struct ModelListResponse : Decodable {
    var data: [ModelItem]
}
public struct ModelItem : Decodable {
    var id: String
    var owned_by: String
}
