//
//  Movie+CoreDataProperties.swift
//  Movies Info
//
//  Created by Prashant Pandey on 07/09/22.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var voteAvg: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var overView: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var type: String?
    @NSManaged public var posterPath: String?

}

extension Movie : Identifiable {

}
