//
//  File.swift
//  
//
//  Created by Yuliia on 02/05/24.
//

import Foundation
import JWT

// verifying token for authorization

struct AuthPayload: JWTPayload {
    typealias Payload = AuthPayload
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userID = "uid"
    }
    
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userID: UUID
    
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
