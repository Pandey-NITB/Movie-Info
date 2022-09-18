//
//  LocalMovieDataParser.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 06/09/22.
//

import Foundation

struct LocalMovieDataParser {
    static func parseLocalMovieItemData(_ items: [Movie], movieType: MovieType) throws -> [MovieItem] {
        var movieItems = [MovieItem]()
        if items.count > 0 {
            for index in 0..<items.count {
                movieItems.append(MovieItem(id: Int(items[index].id),
                                            isFavorite: false,
                                            overView: items[index].overView ?? "",
                                            title: items[index].title ?? "",
                                            type: movieType.rawValue,
                                            voteAvg: items[index].voteAvg ?? "",
                                            posterPath: items[index].posterPath ?? "",
                                            relaseDate: items[index].releaseDate ?? ""))
            }
            return movieItems
        }
        throw MovieDataError.zeroItems
    }
    
    static func parseFavMovieData(_ items: [Movie], movieType: MovieType = .none) throws -> [MovieItem] {
        var movieItems = [MovieItem]()
        if items.count > 0 {
            for index in 0..<items.count {
                movieItems.append(MovieItem(id: Int(items[index].id),
                                            isFavorite: true,
                                            overView: items[index].overView ?? "",
                                            title: items[index].title ?? "",
                                            type: movieType.rawValue,
                                            voteAvg: items[index].voteAvg ?? "",
                                            posterPath: items[index].posterPath ?? "",
                                            relaseDate: items[index].releaseDate ?? ""))
            }
            return movieItems
        }
        throw MovieDataError.zeroItems
    }
}
