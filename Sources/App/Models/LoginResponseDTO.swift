//
//  File.swift
//  
//
//  Created by Yuliia on 02/05/24.
//

import Foundation
import Vapor

struct LoginResponseDTO: Content {
    let error: Bool
    var reason: String? = nil
    let token: String?
    let userId: UUID
}
