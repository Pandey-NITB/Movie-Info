//
//  MovieDetailViewModel.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

class MovieDetailViewModel {
    private var serviceType: MovieDetailService!
    
    private var movieItemResult: MovieItem!
    
    weak var viewDelegate: ResponseViewAdapter?
    
    var isFavorite = false
    var movieId: String!
    
    init(serviceType: MovieDetailService) {
        self.serviceType = serviceType
    }
    
    func fetchMovieDetail() {
        serviceType.fetchMovieDetailData(dataServiceType: .movieDetails(self.movieId)) { [weak self] (result) in
            switch result {
            case .success(let movieDetail):
                self?.movieItemResult = movieDetail
                self?.viewDelegate?.onSuccess()
            case .failure(let error):
                self?.viewDelegate?.showError(message: error.getErrorDescription())
                print("error is \(error.localizedDescription)")
            }
        }
    }
    
    func favButtonClicked(id: Int) {
        PersistanceManager.shared.toggleFavState(id: Int64(id))
    }
    
    func getMovie() -> MovieItem? {
        self.movieItemResult
    }
    
    func getMoviePosterPathString() -> String {
        if let posterPath = movieItemResult?.posterPath {
            return Constants.largePosterPath + posterPath
        }
        return ""
    }
    
    func getMovieTitle() -> String? {
        return movieItemResult.title
    }
    
    func getMovieReleaseData() -> String? {
        return "".formatedReleaseDate(self.movieItemResult.relaseDate)
    }
    
    func getMovieAvgVotes() -> String? {
        return movieItemResult?.voteAvg
    }
    
    func getMoviegenres() -> String? {
       return ""
    }
    
    func getMovieOverView() -> String? {
        return movieItemResult?.overView
    }
    
    func isMovieFav(for movieID: Int) -> Bool {
        PersistanceManager.shared.isFavMovie(id: Int64(movieID))
    }
    
    func getFavButtonStateImage(for movieID: Int) -> String {
        if self.isMovieFav(for: movieID) {
            return "icon_fav"
        } else {
            return "icon_fav_selelcted"
        }
    }
    
    private func formatedReleaseDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: date) {
            return date.MMMDYYYYFormat()
        }
        return ""
    }
}

protocol MovieDetailDeleagte: AnyObject {
    func getMovieDetail()
    func showErrorMessage()
}
