//
//  MainScreenWorker.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

protocol MainScreenWorkerProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoResponse], Error>) -> Void)
    func fetchUsers(completion: @escaping (Result<[UserResponse], Error>) -> Void)
}

struct MainScreenWorker: MainScreenWorkerProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = .shared) {
        self.client = client
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoResponse], Error>) -> Void) {
        client.request(target: .fetchTodos, completion: completion)
    }
    
    func fetchUsers(completion: @escaping (Result<[UserResponse], Error>) -> Void) {
        client.request(target: .fetchUsers, completion: completion)
    }
}
