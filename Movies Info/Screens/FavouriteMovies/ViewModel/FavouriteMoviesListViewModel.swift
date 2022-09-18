//
//  FavouriteMoviesListViewModel.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 07/09/22.
//

import Foundation

class FavouriteMoviesListViewModel {
    private var serviceType: FavouriteMoviesListService!
    
    private var movieItemResults: [MovieItem]? = []
    
    private var currentPage = 1
    
    weak var viewDelegate: ResponseViewAdapter?
    
    init(serviceType: FavouriteMoviesListService) {
        self.serviceType = serviceType
    }
    
    func fetchFavMovies() {
        serviceType.fetchFavouriteoviesData { [weak self] (result) in
            switch result {
            case .success(let movieItems):
                self?.movieItemResults = movieItems
                self?.viewDelegate?.onSuccess()
            case .failure(let error):
                self?.viewDelegate?.showError(message: error.getErrorDescription())
            }
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
}
