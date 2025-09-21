//
//  HTTPClient.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation
import Moya

final class HTTPClient {
    private let provider = MoyaProvider<ToDoService>(session: .default)
    
    static let shared = HTTPClient()
    
    private init() {
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
    }
    
    func request<Response: Decodable>(target: ToDoService, completion: @escaping (Result<Response, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(Response.self, from: response.data)
                    completion(.success(response))
                } catch(let error) {
                    debugPrint(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
