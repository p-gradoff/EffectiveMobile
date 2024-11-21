//
//  NetworkManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

protocol NetworkOutput: AnyObject {
    func doRequest(_ completion: @escaping (Result<RawTaskList, NetworkError>) -> Void)
}

// MARK: - network errors to decect error's kind
enum NetworkError: String, Error {
    case networkError = "Network error"
    case responseError = "Response Error"
    case serverError = "Server error"
    case dataError = "Data error"
    case parseError = "Parsing error"
    
    static func get(_ err: NetworkError) -> String {
        switch err {
        case .networkError: return "Network error descpiption"
        case .responseError: return "Response error descpiption"
        case .serverError: return "Server error descpiption"
        case .dataError: return "Data error descpiption"
        case .parseError: return "Parsing error descpiption"
        }
    }
}

final class NetworkManager: NetworkOutput {
    // MARK: - base url to get data
    private let basedURL: URL = URL(string: "https://dummyjson.com/todos")!
    
    // MARK: - form request with parameters
    private func formRequest() -> URLRequest {
        var request = URLRequest(url: basedURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    // MARK: - do request by formed request
    func doRequest(_ completion: @escaping (Result<RawTaskList, NetworkError>) -> Void) {
        let request = formRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccess() else {
                completion(.failure(NetworkError.responseError))
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
