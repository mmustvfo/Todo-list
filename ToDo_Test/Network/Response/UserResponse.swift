//
//  UserResponse.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let website: String
    
    struct Address: Decodable {
        let city: String
    }
}
