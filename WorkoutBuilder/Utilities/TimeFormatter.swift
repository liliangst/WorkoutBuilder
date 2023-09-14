//
//  TimeFormatter.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 13/09/2023.
//

import Foundation

class TimeFormatter {
    
    static func formatToString(timeInMilliseconds: UInt) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: (TimeInterval(timeInMilliseconds) / 1000))
        return dateFormatter.string(from: date)
    }
}
