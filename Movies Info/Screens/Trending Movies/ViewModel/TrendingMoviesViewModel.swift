//
//  TrendingMoviesViewModel.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 23/08/22.
//

import Foundation
import CoreData

enum MovieType : String {
    case trending
    case nowPlaying = "now_playing"
    case none
}

class TrendingMoviesViewModel {
    
    private var serviceType: TrendingMovieService!
    
    private var movieItemResults: [MovieItem]? = []
    
    private var currentPage = 1
    
    weak var viewDelegate: ResponseViewAdapter?
    
    init(serviceType: TrendingMovieService = RemoteWithLocalTrendingMovieService()) {
        self.serviceType = serviceType
    }
    
    func fetchTrendingMovies(page: Int) {
       print("page is \(page)")
        currentPage = page
        let queryItem = URLQueryItem(name: "page", value: "\(page)")
        serviceType.fetchTrendingMoviesData(dataServiceType: .trendingMovie([queryItem])) { [weak self] (result) in
            switch result {
            case .success(let trendingMovieItems):
                if let newData = self?.movieItemResults {
                    if newData.count > 0 {
                        self?.movieItemResults?.append(contentsOf: trendingMovieItems)
                    } else {
                        self?.movieItemResults = trendingMovieItems
                    }
                }
                self?.saveMoviesInLocalDB(items: trendingMovieItems)
                self?.viewDelegate?.onSuccess()
            case .failure(let error):
                self?.viewDelegate?.showError(message: error.getErrorDescription())
                print("error is \(error.localizedDescription)")
            }
        }
    }
    
    func saveMoviesInLocalDB(items: [MovieItem]) {
        if let movieItemResults = movieItemResults, movieItemResults.count > 0 {
            self.serviceType.saveTrendingMovies(movieItem: self.movieItemResults!, type: MovieType.nowPlaying.rawValue)
        }
    }
    
    func getMovieReaults() -> [MovieItem]? {
        movieItemResults
    }
    
    func getNumberOfMovieItems() -> Int {
        movieItemResults?.count ?? 0
    }
    
    func getCurrentPageIndex() -> Int {
        currentPage
    }
    
    func getMovieId(index: Int) -> String {
        return movieItemResults?[index].id.toString() ?? ""
    }
    
    func isMovieFav(index: Int) -> Bool {
        return movieItemResults?[index].isFavorite ?? false
    }
}
