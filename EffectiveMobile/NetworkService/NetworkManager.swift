//
//  NetworkManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

protocol NetworkOutput: AnyObject {
    func doRequest(_ completion: @escaping (Result<RawTaskList, Error>) -> Void)
}

enum NetworkError: Error {
    case networkError
    case responseConvertError
    case serverError
    case dataError
    case parseError
    
    static func get(_ err: NetworkError) -> String {
        switch err {
        case .networkError: return "Network error"
        case .responseConvertError: return "HTTP Response converting Error"
        case .serverError: return "Server error"
        case .dataError: return "Data error"
        case .parseError: return "Parsing error"
        }
    }
}

final class NetworkManager: NetworkOutput {
    private let basedURL: URL = URL(string: "https://dummyjson.com/todos")!
    
    private func formRequest() -> URLRequest {
        var request = URLRequest(url: basedURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func doRequest(_ completion: @escaping (Result<RawTaskList, Error>) -> Void) {
        let request = formRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.responseConvertError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            
            do {
                let responseBody = try JSONDecoder().decode(RawTaskList.self, from: data)
                completion(.success(responseBody))
            } catch {
                completion(.failure(NetworkError.parseError))
            }
            
        }.resume()
    }
}
