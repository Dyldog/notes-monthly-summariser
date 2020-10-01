import Foundation

let summaryTags = ["summary"]
let dailyNotesFolder = "daily notes"
let basePath = "/Users/dylanelliott/Bear/notes"
let summaryPaths = try! FileManager().contentsOfDirectory(atPath: basePath)

let regex = try! NSRegularExpression(pattern: "(\\d{4})-(\\d{2})-(\\d{2})\\.md")

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

let summaryText = noteSummary.summary()
let summaryFile = BearFile(
    title: "Summary",
    path: "\(generatedSummaryPath)/Summaries.md",
    tags: summaryTags
)
summaryFile.write(summaryText)

noteSummary.summaries.forEach { year in
    let yearSummaryText = year.summary()
    let yearSummaryFile = BearFile(
        title: year.filename,
        path: "\(generatedSummaryPath)/\(year.filename).md",
        tags: summaryTags
    )
    yearSummaryFile.write(yearSummaryText)
    
    year.summaries.forEach { month in
        let monthSummary = month.summary
        let monthSummaryFile = BearFile(
            title: month.filename,
            path: "\(generatedSummaryPath)/\(month.filename).md",
            tags: summaryTags
        )
        monthSummaryFile.write(monthSummary)
    }
}

