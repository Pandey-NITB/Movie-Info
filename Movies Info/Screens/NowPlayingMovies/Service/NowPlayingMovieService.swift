//
//  NowPlayingMovieService.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

protocol NowPlayingMovieService {
   func fetchNowPlayingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void)
    func saveNowPlayingMovies(movieItem: [MovieItem], type: String)
}

final class RemoteNowPlayingMovieService: NowPlayingMovieService  {
    let client: NetworkClientServiceHandler!
    private var isRequestInProgress: Bool = false

    public init(client: URLSession = .init(configuration: .default)) {
        self.client = client
    }
    
    func fetchNowPlayingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
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

final class LocalNowPlayingMovieService: NowPlayingMovieService {
    private var isRequestInProgress: Bool = false
    private let deadline: DispatchTime
    private var persistenceManager: PersistenceService!
    
    init(deadline: DispatchTime = .now(), persistenceManager: PersistenceService = PersistanceManager.shared) {
        self.deadline = deadline
        self.persistenceManager = persistenceManager
    }
    
    func fetchNowPlayingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        guard !isRequestInProgress else { return }
        
        isRequestInProgress = true
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            do {
                if let movieItems = self?.persistenceManager.getFilteredMoviesOf(type: "now_playing") {
                    
                    let movies = try LocalMovieDataParser.parseLocalMovieItemData(movieItems, movieType: .nowPlaying)
                    completion(.success(movies))
                    self?.isRequestInProgress = false
                }
            } catch {
                self?.isRequestInProgress = false
                completion(.failure(error as? MovieDataError ?? .dataNotFound))
            }
        }
    }
    
    func saveNowPlayingMovies(movieItem: [MovieItem], type: String) {
        self.persistenceManager.saveMovisListInCoreData(movieItemResults: movieItem, type: type)
    }
}

final class RemoteWithLocalNowPlayingMovieService: NowPlayingMovieService {
    let remoteService: RemoteNowPlayingMovieService!
    let localService: LocalNowPlayingMovieService!
    
    init(remoteService: RemoteNowPlayingMovieService = RemoteNowPlayingMovieService(), localService:LocalNowPlayingMovieService = LocalNowPlayingMovieService()) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func fetchNowPlayingMoviesData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            remoteService.fetchNowPlayingMoviesData(dataServiceType: dataServiceType, completion: completion)
        } else {
            localService.fetchNowPlayingMoviesData(dataServiceType: dataServiceType, completion: completion)
        }
    }
    
    func saveNowPlayingMovies(movieItem: [MovieItem], type: String) {
        self.localService.saveNowPlayingMovies(movieItem: movieItem, type: type)
    }
}

extension NowPlayingMovieService {
    func saveNowPlayingMovies(movieItem: [MovieItem], type: String) {}
}
