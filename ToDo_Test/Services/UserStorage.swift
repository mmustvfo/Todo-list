//
//  UserStorage.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

final class UserStorage {
    static let shared = UserStorage()
    
    private init() {}
    
    @UserDefault(
        key: Constants.Keys.todos,
        name: "todos",
        defaultValue: []
    )
    var todos: [TodoRowDescriptor]
}

extension UserStorage {
    enum Constants {
        enum Keys {
            static let todos = "todosie293rjwe8dfewiond"
        }
    }
}
