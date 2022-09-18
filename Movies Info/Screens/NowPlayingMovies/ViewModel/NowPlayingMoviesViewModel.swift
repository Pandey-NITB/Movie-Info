//
//  NowPlayingMoviesViewModel.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//
import Foundation
import CoreData

class NowPlayingMoviesViewModel {
    
    private var serviceType: NowPlayingMovieService!
    
    private var movieItemResults: [MovieItem]? = []
    
    private var currentPage = 1
    
    weak var viewDelegate: ResponseViewAdapter?
    
    init(serviceType: NowPlayingMovieService) {
        self.serviceType = serviceType
    }
    
    func fetchNowPlayingMovies(page: Int) {
        currentPage = page
        let queryItem = URLQueryItem(name: "page", value: "\(page)")
        serviceType.fetchNowPlayingMoviesData(dataServiceType: .nowPlayingMovie([queryItem])) { [weak self] (result) in
            switch result {
            case .success(let nowPlayingMovieItems):
                if let newData = self?.movieItemResults {
                    if newData.count > 0 {
                        self?.movieItemResults?.append(contentsOf: nowPlayingMovieItems)
                    } else {
                        self?.movieItemResults = nowPlayingMovieItems
                    }
                }
                self?.saveMoviesInLocalDB(items: nowPlayingMovieItems)
                self?.viewDelegate?.onSuccess()
            case .failure(let error):
                self?.viewDelegate?.showError(message: error.getErrorDescription())
                print("error is \(error.getErrorDescription())")
            }
        }
    }
    
    func saveMoviesInLocalDB(items: [MovieItem]) {
        if let movieItemResults = movieItemResults, movieItemResults.count > 0 {
            self.serviceType.saveNowPlayingMovies(movieItem: self.movieItemResults!, type: MovieType.nowPlaying.rawValue)
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

protocol ResponseViewAdapter: AnyObject {
    func onSuccess()
    func showError(message: String)
}
