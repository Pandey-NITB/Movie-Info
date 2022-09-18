//
//  RemoteRemoteMovieDataParser.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 06/09/22.
//

import Foundation

struct RemoteMovieDataParser {
    static func parse(_ dto: MovieItemsDTO?, type: MovieType) throws -> [MovieItem] {
        var items = [MovieItem]()
        if let movieDTO = dto {
            if let results = movieDTO.results, results.count > 0 {
                for index in 0..<results.count {
                    items.append(MovieItem(id: results[index].id!,
                                           isFavorite: false,
                                           overView: results[index].overview ?? "",
                                           title: results[index].title ?? "",
                                           type: type.rawValue,
                                           voteAvg: results[index].voteAverage?.toString() ?? "",
                                           posterPath: results[index].posterPath ?? "",
                                           relaseDate: results[index].releaseDate ?? ""))
                }
            }
            return items
        }
        throw MovieDataError.zeroItems
    }
    
    static func parseMovieDetails(_ dto: MovieItemData?, type: MovieType) throws -> MovieItem {
        var item: MovieItem!
        if let movieDTO = dto {
            item = MovieItem(id: movieDTO.id!,
                             isFavorite: false,
                             overView: movieDTO.overview ?? "",
                             title: movieDTO.title ?? "",
                             type: type.rawValue,
                             voteAvg: "\(String(describing: movieDTO.voteAverage))",
                             posterPath: movieDTO.posterPath ?? "",
                             relaseDate: movieDTO.releaseDate ?? "")
            return item
        }
        throw MovieDataError.zeroItems
    }
}
