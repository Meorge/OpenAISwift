//
//  Errors.swift
//  
//
//  Created by Malcolm Anderson on 9/30/22.
//

import Foundation

enum ResponseError : Error {
case badStatusCode(code: Int)
}
