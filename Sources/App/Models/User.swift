//
//  File.swift
//  
//
//  Created by Yuliia on 01/05/24.
//

import Foundation
import Fluent
import Vapor

final class User: Model, Content, Validatable {
   
    
    static let schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() {}
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
    
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add("username", as: String.self, is: !.empty, customFailureDescription: "How should we call you? Write your username")
        validations.add("password", as: String.self, is: !.empty, customFailureDescription: "Bad people might break in into your account! Please, write a strong password")
        
        validations.add("password", as: String.self, is: .count(6...15), customFailureDescription: "Password should be between 6 and 15 characters")
        
      //  validations.add("password", as: String.self, is: .pattern("^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&? \"]).*$"), customFailureDescription: "Password must be more than 6 characters, with at least one capital, numeric or special character")
    }
    
}
