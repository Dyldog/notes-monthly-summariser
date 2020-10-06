//
//  YearlySummary.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

struct YearlySummary {
    let year: Int
    let summaries: [MonthlySummary]
    
    init(summaries: [DailySummary]) {
        year = summaries.first!.date.year
        
        let months = Dictionary(grouping: summaries, by: { $0.date.month })
        self.summaries = months.values.map {
            MonthlySummary(summaries: $0)
        }
    }
    
    func summary() -> String {
        let header = """
        # \(year)
        """
        let dailies = summaries.map {
            "* [[\($0.date.month.month!) \($0.date.year)]]"
        }
        
        return dailies.joined(separator: "\n")
    }
    
    var filename: String { return "\(year)" }
}
