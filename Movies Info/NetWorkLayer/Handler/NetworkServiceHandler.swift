//
//  NetworkManager.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 18/08/22.

import Foundation

protocol NetworkClientServiceHandler {
    func fetchData<T: Codable>(request: URL, completion: @escaping (Result<T, MovieDataError>) -> Void)
}

extension URLSession: NetworkClientServiceHandler {
    func fetchData<T>(request: URL, completion: @escaping (Result<T, MovieDataError>) -> Void) where T : Decodable {
        print("url is \(request)")
        dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                if let data = data {
                    if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                        completion(.success(decodedData))
                    } else {
                        completion(.failure(error as? MovieDataError ?? .dataParsingFailed))
                    }
                } else if let error = error {
                    completion(.failure(error as? MovieDataError ?? .unknown))
                }
            }
        }).resume()
    }
}

enum APIServiceMethod: String {
    case get = "GET"
    case post = "POST"
}
