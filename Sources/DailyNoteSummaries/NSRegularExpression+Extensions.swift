//
//  NSRegularExpression+Extensions.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

extension NSRegularExpression {
    func firstMatch(in string: String) -> NSTextCheckingResult? {
        self.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    }
}

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
