//
//  FavouriteMoviesListService.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 07/09/22.
//

import Foundation
import Foundation

protocol FavouriteMoviesListService {
   func fetchFavouriteoviesData(completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void)
}

final class LocalFavouriteMoviesListService: FavouriteMoviesListService {
    
    private var isRequestInProgress: Bool = false
    private let deadline: DispatchTime
    private var persistenceManager: PersistenceService!
    
    init(deadline: DispatchTime = .now(), persistenceManager: PersistenceService = PersistanceManager.shared) {
        self.deadline = deadline
        self.persistenceManager = persistenceManager
    }
    
    func fetchFavouriteoviesData(completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        guard !isRequestInProgress else { return }
        
        isRequestInProgress = true
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            do {
                if let movieItems = self?.persistenceManager.getFavMovies() {
                    
                    let movies = try LocalMovieDataParser.parseFavMovieData(movieItems)
                    completion(.success(movies))
                    self?.isRequestInProgress = false
                }
            } catch {
                self?.isRequestInProgress = false
                completion(.failure(error as? MovieDataError ?? .dataNotFound))
            }
        }
    }
}

