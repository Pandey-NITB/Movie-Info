//
//  DeepLinkParser.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 06/09/22.
//

import Foundation

struct DeepLinkParser {
    static func parse(urlString: URL) -> MovieInfoAppViewType? {
        let movieID = urlString.lastPathComponent
        return .movieDetail(String(movieID))
    }
}
