//
//  Constants.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 18/08/22.
//

import Foundation
import UIKit

struct Constants {
    
    static let moviesItemCellID = "MovieItemCollectionViewCell"
    static let smallPosterPath = "https://image.tmdb.org/t/p/w300"
    static let largePosterPath = "https://image.tmdb.org/t/p/original"
    
    static let searchPlaceholderText = "Search for movies..."
    static let trendingMovieTitle = "Trending Movies"
    static let nowPlayingMovieText = "Now Playing Movies"
    static let favMovieText = "Favourite Movies"
    
    static let searchVCIdentifier = "SearchViewController"
    static let nowPlayingVCIdentifier = "NowPlayingMoviesViewController"
    static let trendingMoviesVCIdentifier = "TrendingMoviesViewController"
    static let movieDetailVCTIdentifier = "MovieDetailViewController"
    static let favVCIdentifier = "FavouriteMoviesListViewController"
    
    struct coreData {
        let movie = "Movie"
    }

    struct api {
        let key = "91c9a189dae01847e5be40acef45c1d2"
        let language = "en-US"
        let url = "https://api.themoviedb.org/3"
    }

    struct color {
        let darkGreen = UIColor(rgb: 0x081C25)
        let lightGreen = UIColor(rgb: 0x02D475)
    }
}
