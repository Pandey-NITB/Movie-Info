//
//  DataServiceType.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

enum DataServiceType: APIRequestType {
    var path: String {
        switch self {
        case .trendingMovie(_):
            return "/trending/all/week"
        case .nowPlayingMovie(_):
            return "/movie/now_playing"
        case .movieDetails(let string):
            return "/movie/" + string
        case .search(_):
            return "/search/movie"
        }
    }
    
    case trendingMovie([URLQueryItem])
    case nowPlayingMovie([URLQueryItem])
    case movieDetails(String)
    case search([URLQueryItem])
    
    func getApiUrl(queryItems: [URLQueryItem] = []) -> URL {
        var query = [
            URLQueryItem(name: "api_key", value: Constants.api().key),
            URLQueryItem(name: "language", value: Constants.api().language)
        ]
        switch self {
        case .trendingMovie(let queryItems),
                .nowPlayingMovie(let queryItems),
                .search(let queryItems):
            query.append(contentsOf: queryItems)
        default: break
        }
        
        var urlComponents = URLComponents(string: "\(baseUrl)\(path)")
        urlComponents?.queryItems = query
        return urlComponents?.url ?? URL(string: "")!
    }
}
