//
//  TrendingMovieService.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 23/08/22.
//

import Foundation

protocol TrendingMovieService {
   func fetchTrendingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void)
   func saveTrendingMovies(movieItem: [MovieItem], type: String)
}

class RemoteTrendingMovieService: TrendingMovieService  {
    let client: NetworkClientServiceHandler!
    private var isRequestInProgress: Bool = false

    public init(client: URLSession = .init(configuration: .default)) {
        self.client = client
    }
    
    func fetchTrendingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        client.fetchData(request: dataServiceType.getApiUrl()) {
            completion(self.handleResult($0))
        }
    }
    
    private func handleResult(_ result: Result<MovieItemsDTO, MovieDataError>) -> Result<[MovieItem], MovieDataError> {
        var movieItem: [MovieItem]!
        switch result {
        case .success(let dto):
            self.isRequestInProgress = false
            do {
                movieItem = try RemoteMovieDataParser.parse(dto, type: .trending)
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

final class LocalTrendingMovieService: TrendingMovieService {
    
    private var isRequestInProgress: Bool = false
    private let deadline: DispatchTime
    private var persistenceManager: PersistenceService!
    
    init(deadline: DispatchTime = .now(), persistenceManager: PersistenceService = PersistanceManager.shared) {
        self.deadline = deadline
        self.persistenceManager = persistenceManager
    }
    
    func fetchTrendingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        guard !isRequestInProgress else { return }
        
        isRequestInProgress = true
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            do {
                if let movieItems = self?.persistenceManager.getFilteredMoviesOf(type: MovieType.trending.rawValue) {
                    
                    let movies = try LocalMovieDataParser.parseLocalMovieItemData(movieItems, movieType: .trending)
                    completion(.success(movies))
                    self?.isRequestInProgress = false
                }
            } catch {
                self?.isRequestInProgress = false
                completion(.failure(error as? MovieDataError ?? .dataNotFound))
            }
        }
    }
    
    func saveTrendingMovies(movieItem: [MovieItem], type: String) {
        self.persistenceManager.saveMovisListInCoreData(movieItemResults: movieItem, type: type)
    }
}

final class RemoteWithLocalTrendingMovieService: TrendingMovieService {
    let remoteService: RemoteTrendingMovieService!
    let localService: LocalTrendingMovieService!
    
    init(remoteService: RemoteTrendingMovieService = RemoteTrendingMovieService(), localService:LocalTrendingMovieService = LocalTrendingMovieService()) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func fetchTrendingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            print("calling from remote")
            remoteService.fetchTrendingMoviesData(dataServiceType: dataServiceType, completion: completion)
        } else {
            print("calling from local")
            localService.fetchTrendingMoviesData(dataServiceType: dataServiceType, completion: completion)
        }
    }
    
    func saveTrendingMovies(movieItem: [MovieItem], type: String) {
        self.localService.saveTrendingMovies(movieItem: movieItem, type: type)
    }
}

extension TrendingMovieService {
    func saveTrendingMovies(movieItem: [MovieItem], type: String) {}
}

