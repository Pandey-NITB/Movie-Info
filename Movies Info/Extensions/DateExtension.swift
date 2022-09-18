//
//  DateExtension.swift
//  Movies Info
//
//  Created by Prashant Pandey on 08/09/22.
//

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func MMMDYYYYFormat() -> String {
        var finalString = ""
        Date.formatter.dateFormat = "MMM d, YYYY"
        finalString += "\(Date.formatter.string(from: self))"
        return finalString
    }
}
