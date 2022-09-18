//
//  MovieDataError.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 23/08/22.
//

import Foundation

public enum MovieDataError: Error {
    case badInput
    case dataNotFound
    case dataParsingFailed
    case zeroItems
    case unknown
    
    func getErrorDescription() -> String {
        switch self {
        case .badInput:
            return  "Provided wrong info. Please Retry!"
        case .dataNotFound:
            return "There is no data right now for this page"
        case .dataParsingFailed:
            return "data parsing failed!"
        case .zeroItems:
            return "You don't have any items for the page"
        default:
           return "Something went wrong, Please retry again"
        }
    }
}


