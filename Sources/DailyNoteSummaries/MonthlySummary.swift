//
//  MonthlySummary.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

struct MonthlySummary {
    let date: (month: Int, year: Int)
    let summaries: [DailySummary]
    
    init(summaries: [DailySummary]) {
        let firstSummary = summaries.first!
        date = (firstSummary.date.month, firstSummary.date.year)
        self.summaries = summaries
    }
    
    var summary: String {
        let header = """
        # \(date.month.month!) \(date.year)
        """
        let dailies = summaries.map {
            "* [[\($0.date.year)-\(String($0.date.month).leftPadding(toLength: 2, withPad: "0"))-\(String($0.date.day).leftPadding(toLength: 2, withPad: "0"))]]"
        }
        
        return dailies.joined(separator: "\n")
    }
    
    var filename: String { return "\(date.month.month!) \(date.year)" }
}
