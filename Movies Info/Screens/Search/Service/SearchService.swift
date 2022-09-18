//
//  SearchService.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation

protocol SearchService {
    func searchMovieData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void)
   func saveMovies(movieItem: [MovieItem], type: String)
}

class RemoteSearchService: SearchService  {
    let client: NetworkClientServiceHandler!
    private var isRequestInProgress: Bool = false

    public init(client: URLSession = .init(configuration: .default)) {
        self.client = client
    }
    
    func searchMovieData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
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

final class LocalSearchService: SearchService {
    private var isRequestInProgress: Bool = false
    private let deadline: DispatchTime
    private var persistenceManager: PersistenceService!

    init(deadline: DispatchTime = .now(), persistenceManager: PersistenceService = PersistanceManager.shared) {
        self.deadline = deadline
        self.persistenceManager = persistenceManager
    }

    func searchMovieData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        guard !isRequestInProgress else {
            completion(.failure(.badInput))
            return
        }
        var page   = 0
        var search = ""
        if case .search(let queryItems) = dataServiceType {
            if queryItems.count == 2 {
                if let pageValue = queryItems[0].value {
                    page = Int(pageValue)!
                }

                if let searchValue = queryItems[1].value {
                    search = searchValue
                }
            }
        } else {
            completion(.failure(.badInput))
            return
        }

        isRequestInProgress = true

        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            do {
                if let movies = self?.persistenceManager.searchMovie(text: search, page: page) {

                    let movieItems = try LocalMovieDataParser.parseLocalMovieItemData(movies, movieType: .none)
                    completion(.success(movieItems))
                    self?.isRequestInProgress = false
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

final class RemoteWithLocalSearchService: SearchService {
    let remoteService: RemoteSearchService!
    let localService: LocalSearchService!

    init(remoteService: RemoteSearchService = RemoteSearchService(), localService:LocalSearchService = LocalSearchService()) {
        self.remoteService = remoteService
        self.localService = localService
    }

    func searchMovieData(dataServiceType: DataServiceType, completion: @escaping (Result<[MovieItem], MovieDataError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            remoteService.searchMovieData(dataServiceType: dataServiceType, completion: completion)
        } else {
            localService.searchMovieData(dataServiceType: dataServiceType, completion: completion)
        }
    }


    func saveMovies(movieItem: [MovieItem], type: String) {
        self.localService.saveMovies(movieItem: movieItem, type: type)
    }
}

extension SearchService {
    func saveMovies(movieItem: [MovieItem], type: String) {}
}

