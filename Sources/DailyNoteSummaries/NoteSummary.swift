//
//  NoteSummary.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

struct NoteSummary {
    let summaries: [YearlySummary]
    
    init(dailySummaries: [DailySummary]) {
        let years = Dictionary(grouping: dailySummaries, by: { $0.date.year })
        summaries = years.values.map {
            YearlySummary(summaries: $0)
        }
    }
    
    func summary() -> String {
        let header = """
        # Summary
        """
        let dailies = summaries.map {
            "* [[\($0.year)]]"
        }
        
        return dailies.joined(separator: "\n")
    }
}
