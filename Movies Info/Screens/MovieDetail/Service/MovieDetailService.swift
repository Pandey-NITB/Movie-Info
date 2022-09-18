//
//  MovieDetailService.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

protocol MovieDetailService {
    func fetchMovieDetailData(dataServiceType: DataServiceType, completion: @escaping (Result<MovieItem, MovieDataError>) -> Void)
}

class RemoteMovieDetailService: MovieDetailService {
    let client: NetworkClientServiceHandler!
    private var isRequestInProgress: Bool = false

    public init(client: URLSession = .init(configuration: .default)) {
        self.client = client
    }
    
    func fetchMovieDetailData(dataServiceType: DataServiceType, completion: @escaping (Result<MovieItem, MovieDataError>) -> Void) {
        client.fetchData(request: dataServiceType.getApiUrl()) {
            completion(self.handleResult($0))
        }
    }
    
    private func handleResult(_ result: Result<MovieItemData, MovieDataError>) -> Result<MovieItem, MovieDataError> {
        var movieItem: MovieItem!
        switch result {
        case .success(let dto):
            self.isRequestInProgress = false
            do {
                movieItem = try RemoteMovieDataParser.parseMovieDetails(dto, type: .none)
                return .success(movieItem)
            } catch {
                debugPrint("eb: \(error)")
                return .failure(.dataParsingFailed)
            }
        case .failure:
            return .failure(.dataNotFound)
        }
    }
    
}

class LocalMovieDetailService: MovieDetailService {
    private var isRequestInProgress: Bool = false
    private let deadline: DispatchTime
    private var persistenceManager: PersistenceService!
    
    init(deadline: DispatchTime = .now(), persistenceManager: PersistenceService = PersistanceManager.shared) {
        self.deadline = deadline
        self.persistenceManager = persistenceManager
    }
   
    func fetchMovieDetailData(dataServiceType: DataServiceType, completion: @escaping (Result<MovieItem, MovieDataError>) -> Void) {
        guard !isRequestInProgress else {
            completion(.failure(.badInput))
            return
        }
        
        var movieID = ""
        if case .movieDetails(let movieId) = dataServiceType {
            movieID = movieId
        } else {
            completion(.failure(.badInput))
            return
        }
        
        isRequestInProgress = true
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            do {
                if let movieItems = self?.persistenceManager.getMovieWith(id: Int64(movieID)!) {
                    let movie = try LocalMovieDataParser.parseLocalMovieItemData([movieItems], movieType: .none)
                    completion(.success(movie.first!))
                    self?.isRequestInProgress = false
                } else {
                    completion(.failure(.dataNotFound))
                }
            } catch {
                self?.isRequestInProgress = false
                completion(.failure(error as? MovieDataError ?? .dataNotFound))
            }
        }
    }
    
    func saveMovies(movieItem: [MovieItem], type: String) {
        self.persistenceManager.saveMovisListInCoreData(movieItemResults: movieItem, type: type)
    }
}

class LocalWithRemoteDetailsService: MovieDetailService {
    let remoteService: RemoteMovieDetailService!
    let localService: LocalMovieDetailService!
    
    init(remoteService: RemoteMovieDetailService = RemoteMovieDetailService(), localService:LocalMovieDetailService = LocalMovieDetailService()) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func fetchMovieDetailData(dataServiceType: DataServiceType, completion: @escaping (Result<MovieItem, MovieDataError>) -> Void) {
        
        self.localService.fetchMovieDetailData(dataServiceType: dataServiceType) { (result) in
            switch result {
            case .success( _) : completion(result)
            case .failure( _) :
                self.remoteService.fetchMovieDetailData(dataServiceType: dataServiceType, completion: completion)
            }
        }
    }
    
    func saveMovies(movieItem: [MovieItem], type: String) {
        self.localService.saveMovies(movieItem: movieItem, type: type)
    }
}
