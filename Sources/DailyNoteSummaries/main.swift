import Foundation

let dailyNotesFolder = "daily notes"
let basePath = "/Users/dylanelliott/Bear/notes"
let summaryPaths = try! FileManager().contentsOfDirectory(atPath: basePath)

let regex = try! NSRegularExpression(pattern: "(\\d{4})-(\\d{2})-(\\d{2})\\.md")

extension NSTextCheckingResult {
    func string(forGroup group: Int, in string: String) -> String? {
        guard group < self.numberOfRanges else { return nil }
        let nsRange = self.range(at: group)
        guard nsRange.location != NSNotFound else { return nil }
        if let range = Range(nsRange, in: string) {
            return String(string[range])
        } else {
            return nil
        }
    }
}

extension String {
    var intValue: Int? {
        return Int(self)
    }
}

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

struct MonthlySummary {
    let date: (month: Int, year: Int)
    let summaries: [DailySummary]
    
    init(summaries: [DailySummary]) {
        let firstSummary = summaries.first!
        date = (firstSummary.date.month, firstSummary.date.year)
        self.summaries = summaries
    }
    
    var summary: String {
        let header = "# \(date.month.month!) \(date.year)\n"
        let dailies = summaries.map {
            "* [[\($0.date.year)-\(String($0.date.month).leftPadding(toLength: 2, withPad: "0"))-\(String($0.date.day).leftPadding(toLength: 2, withPad: "0"))]]"
        }
        
        return ([header] + dailies).joined(separator: "\n") + "\n\n"
    }
    
    var filename: String { return "\(date.month.month!) \(date.year)" }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}

extension Int {
    var month: String? {
        switch self {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return nil
        }
    }
}

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
    
    func summary(in folder: String) -> String {
        let header = "# \(year)\n"
        let dailies = summaries.map {
            "* [[\($0.date.month.month!) \($0.date.year)]]"
        }
        
        return ([header] + dailies).joined(separator: "\n") + "\n\n"
    }
    
    var filename: String { return "\(year)" }
}

struct NoteSummary {
    let summaries: [YearlySummary]
    
    init(dailySummaries: [DailySummary]) {
        let years = Dictionary(grouping: dailySummaries, by: { $0.date.year })
        summaries = years.values.map {
            YearlySummary(summaries: $0)
        }
    }
    
    func summary(in folder: String) -> String {
        let header = "# Summaries\n"
        let dailies = summaries.map {
            "* [[\($0.year)]]"
        }
        
        return ([header] + dailies).joined(separator: "\n") + "\n\n"
    }
}

let summaries: [DailySummary] = summaryPaths.compactMap { path in
    let range = NSRange(location: 0, length: path.utf16.count)
    
    if let result = regex.firstMatch(in: path, options: .anchored, range: range),
        let year = result.string(forGroup: 1, in: path)?.intValue,
        let month = result.string(forGroup: 2, in: path)?.intValue,
        let day = result.string(forGroup: 3, in: path)?.intValue {
        return DailySummary(date: (day, month, year), path: "../\(path)")
    } else {
        return nil
    }
}.sorted()

let generatedSummaryPath = "\(basePath)"
let noteSummary = NoteSummary(dailySummaries: summaries)

let summaryText = noteSummary.summary(in: generatedSummaryPath)
try! summaryText.write(toFile: "\(generatedSummaryPath)/index.md", atomically: true, encoding: .utf8)

noteSummary.summaries.forEach { year in
    let yearSummaryText = year.summary(in: generatedSummaryPath)
    try! yearSummaryText.write(
        toFile: "\(generatedSummaryPath)/\(year.filename).md",
        atomically: true,
        encoding: .utf8
    )
    
    year.summaries.forEach { month in
        let monthSummary = month.summary
        try! monthSummary.write(
            toFile: "\(generatedSummaryPath)/\(month.filename).md",
            atomically: true, encoding: .utf8
        )
    }
}

