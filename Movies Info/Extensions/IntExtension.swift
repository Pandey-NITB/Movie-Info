//
//  IntExtension.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 29/08/22.
//

import Foundation

extension Int {
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.2f",self)
    }
}
