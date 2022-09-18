//
//  SearchViewModel.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

class SearchViewModel {
    
    private var serviceType: SearchService!
    
    private var movieItemResults: [MovieItem]? = []
    
    private var currentPage = 1
    
    private var totalPage = 0
    
    weak var viewDelegate: ResponseViewAdapter?
    
    init(serviceType: SearchService) {
        self.serviceType = serviceType
    }
    
    func fetchMovieListWith(text: String,page: Int) {
       print("page is \(page)")
        currentPage = page
        let queryItem = [URLQueryItem(name: "page", value: "\(page)"),
                         URLQueryItem(name: "query", value: "\(text)")]
        serviceType.searchMovieData(dataServiceType: .search(queryItem)) { [weak self] (result) in
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
        if items.count > 0 {
            self.serviceType.saveMovies(movieItem: items, type: MovieType.none.rawValue)
        }
    }
    
    func removePreviousSearchResults() {
        self.movieItemResults = []
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
    
    func getTotalPages() -> Int {
        totalPage
    }

    func getMovieId(index: Int) -> String {
        return movieItemResults?[index].id.toString() ?? ""
    }
    
    func isMovieFav(index: Int) -> Bool {
        return movieItemResults?[index].isFavorite ?? false
    }
}
