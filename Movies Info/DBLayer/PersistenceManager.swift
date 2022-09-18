//
//  PersistenceManager.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 18/08/22.
//

import Foundation
import CoreData
import UIKit

protocol PersistenceService {
    func saveMovisListInCoreData(movieItemResults: [MovieItem], type: String)
    func getFilteredMoviesOf(type: String) -> [Movie]
    func getFavMovies() -> [Movie]
    func toggleFavState(id: Int64)
    func getMoviesData() -> [Movie]
    func deleteAllData(_ entity: String)
    func searchMovie(text: String, page: Int) -> [Movie]
    func isFavMovie(id: Int64) -> Bool
    func getMovieWith(id: Int64) -> Movie?
}

class PersistanceManager: PersistenceService {
    static let shared = PersistanceManager()
    
    private init() {}
    
    func saveMovisListInCoreData(movieItemResults: [MovieItem], type: String) {
        for item in movieItemResults {
            if !self.isEntityAttributeExist(id: item.id, entityName: Constants.coreData().movie) {
                if let movie = NSEntityDescription.insertNewObject(forEntityName: Constants.coreData().movie, into: CoreDataStack.shared.viewContext) as? Movie {
                    movie.title = item.title
                    movie.isFavourite = false
                    movie.overView = item.overView
                    movie.id = Int64(item.id)
                    movie.posterPath = item.posterPath
                    movie.voteAvg = item.voteAvg
                    movie.type = type
                    movie.releaseDate = item.relaseDate

                    do {
                       try CoreDataStack.shared.viewContext.save()
                    } catch {
                        debugPrint("data not saved")
                    }
                }
            }
            else {
               
            }
        }
   }
    
    func getFilteredMoviesOf(type: String) -> [Movie] {
        var resultData: [Movie] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreData().movie)
        let filterPredicate = NSPredicate(format: "type == %@", type)
        fetchRequest.predicate = filterPredicate
        
        do {
            resultData = try CoreDataStack.shared.viewContext.fetch(fetchRequest) as! [Movie]
        } catch {
            debugPrint("not able to find this data")
        }
        
        return resultData
    }
    
    func getMovieWith(id: Int64) -> Movie? {
        var resultData: [Movie] = []
        let fetchRequest = Movie.fetchRequest()
        let filterPredicate =  NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = filterPredicate
        do {
            resultData = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if resultData.count != 0 {
                return resultData[0]
            }
        } catch {
            debugPrint("not able to find this data")
        }
        
        return nil
        
    }
   
    func getFavMovies() -> [Movie] {
        var resultData: [Movie] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreData().movie)
        let filterPredicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        fetchRequest.predicate = filterPredicate
        
        do {
            resultData = try CoreDataStack.shared.viewContext.fetch(fetchRequest) as! [Movie]
        } catch {
            debugPrint("not able to find this data")
        }
        
        return resultData
    }
    
    func isFavMovie(id: Int64) -> Bool {
        let fetchRequest = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let results = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if results.count != 0 {
                return results.first?.isFavourite ?? false
            }
        } catch let error as NSError {
            debugPrint("Fetch failed: \(error.localizedDescription)")
        }
        return false
    }
    
    func toggleFavState(id: Int64) {
        let fetchRequest = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let results = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if results.count != 0 {
                results.first?.isFavourite = !(results.first?.isFavourite ?? false)
                do {
                    try CoreDataStack.shared.viewContext.save()
                } catch {
                    print("data not saved")
                }
            }
        } catch let error as NSError {
            // failure
            debugPrint("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func getMoviesData() -> [Movie] {
        var data: [Movie] = []
        
        let fetchRequest = Movie.fetchRequest()
        
        do {
            data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
        } catch {
            debugPrint("can not get data")
        }
        
        return data
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataStack.shared.viewContext.fetch(fetchRequest) as! [Movie]
            for object in results {
                CoreDataStack.shared.viewContext.delete(object)
            }
        } catch let error {
            debugPrint("Detele all data in \(entity) error :", error)
        }
    }
    
    
    
    func searchMovie(text: String = "", page: Int) -> [Movie] {
        var resultData: [Movie] = []
        let fetchRequest = Movie.fetchRequest()

        if !text.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", text)
        }

        fetchRequest.fetchLimit = 20 
        fetchRequest.fetchOffset = (page - 1) * 20
        
        do {
            resultData = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
        } catch {
            print("not able to find this data")
        }
        
        return resultData
    }
}

extension PersistanceManager {
    func isEntityAttributeExist(id: Int, entityName: String) -> Bool {
        var res: [NSFetchRequestResult] = []
        let managedContext = CoreDataStack.shared.viewContext
        let fetchRequest = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
             res = try managedContext.fetch(fetchRequest)
        } catch {
            print("no data found")
        }
       
        return res.count > 0 ? true : false
    }
}
 
