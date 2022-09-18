//
//  APIServiceType.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 23/08/22.
//
import Foundation

protocol APIRequestType {
    var baseUrl: String { get }
    var path: String { get }
    var method: APIServiceMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String: Any] { get }
    func getApiUrl(queryItems: [URLQueryItem]) -> URL
}

extension APIRequestType {
    var baseUrl: String {
        Constants.api().url  //"https://api.themoviedb.org/3"
    }
    
    var headers: [String: Any] {
         ["": ""]
    }
    
    var parameters: [String : Any] {
        ["": ""]
    }
    
    var method: APIServiceMethod {
        .get
    }
}


