//
//  DailySummary.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

struct DailySummary: Comparable {
    static func < (lhs: DailySummary, rhs: DailySummary) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: DailySummary, rhs: DailySummary) -> Bool {
        return lhs.date == rhs.date
    }
    
    let date: (day: Int, month: Int, year: Int)
    let path: String
}
