//
//  RemoteMovieDataParser.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 05/09/22.
//

import Foundation

public struct MovieItem: Identifiable {
    public let id: Int
    var isFavorite: Bool
    var overView: String
    var title: String
    var type: String
    var voteAvg: String
    var posterPath: String
    var relaseDate: String
}
