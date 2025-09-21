//
//  TodoResponse.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

struct TodoResponse: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
