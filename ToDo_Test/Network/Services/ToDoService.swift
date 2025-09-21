//
//  ToDoService.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation
import Moya

enum ToDoService: TargetType {
    case fetchTodos
    case fetchUsers
    
    var baseURL: URL { URL(string: "https://jsonplaceholder.typicode.com")! }
    
    var path: String {
        switch self {
        case .fetchTodos: "todos"
        case .fetchUsers: "users"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestPlain
    }
    
    var headers: [String : String]? { [:] }
    
    
}
