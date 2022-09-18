//
//  MovieInfoViewControllerFactory.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 31/08/22.
//

import Foundation
import UIKit

protocol ViewComposerFactory {
    associatedtype MovieAppView
    func composeView(type: MovieInfoAppViewType) -> MovieAppView
}

enum MovieInfoAppViewType {
    case playingNow
    case trendingMovies
    case search
    case movieDetail(String)
    case favMovies
}

enum TabBarType {
    case playingNow
    case trending
    case search
    case fav
}

class MovieInfoViewControllerFactory: ViewComposerFactory {
    func composeView(type: MovieInfoAppViewType) -> UIViewController {
        switch type {
        case .playingNow:
            let viewModel = NowPlayingMoviesViewModel(serviceType: RemoteWithLocalNowPlayingMovieService())
            let controller = NowPlayingMoviesViewController(viewModel: viewModel)
            controller.tabBarItem = self.getTabBarItem(type: .playingNow)
            return controller
            
        case .trendingMovies:
            let viewModel = TrendingMoviesViewModel(serviceType: RemoteWithLocalTrendingMovieService())
            let controller = TrendingMoviesViewController(viewModel: viewModel)
            controller.tabBarItem = self.getTabBarItem(type: .trending)
            return controller
            
        case .search:
            let viewModel = SearchViewModel(serviceType: RemoteWithLocalSearchService())
            let controller = SearchViewController(viewModel: viewModel)
            controller.tabBarItem = self.getTabBarItem(type: .search)
            return controller
            
        case .movieDetail(let movieId):
            let viewModel = MovieDetailViewModel(serviceType: LocalMovieDetailService())
            viewModel.movieId = movieId
            return MovieDetailViewController(viewModel: viewModel)
            
        case .favMovies:
            let viewModel = FavouriteMoviesListViewModel(serviceType:  LocalFavouriteMoviesListService())
            let controller = FavouriteMoviesListViewController(viewModel: viewModel)
            controller.tabBarItem = self.getTabBarItem(type: .fav)
            return controller
        }
    }
}

extension MovieInfoViewControllerFactory {
    func getTabBarItem(type: TabBarType) -> UITabBarItem {
        switch type {
        case .playingNow: return UITabBarItem(
            title: "Playing Now",
            image: UIImage(named: "icon_movies"),
            selectedImage: UIImage(named: "icon_movies"))
            
        case .trending: return UITabBarItem(
            title: "Trending",
            image: UIImage(named: "icon_trending"),
            selectedImage: UIImage(named: "icon_trending"))
            
        case .search: return UITabBarItem(
            title: "Search",
            image: UIImage(named: "icon_search"),
            selectedImage: UIImage(named: "icon_search"))
        
        case .fav: return UITabBarItem(
            title: "Favourites",
            image: UIImage(named: "icon_tab_star"),
            selectedImage: UIImage(named: "icon_tab_star"))
        }
    }
}


