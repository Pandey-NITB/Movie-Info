//
//  StringExtension.swift
//  Movies Info
//
//  Created by Prashant Pandey on 08/09/22.
//

import Foundation

extension String {
    func formatedReleaseDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: date) {
            return date.MMMDYYYYFormat()
        }
        return ""
    }
}
