//
//  File.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

class File {
    let path: String
    var contents: String? {
        return try? String(contentsOfFile: path)
    }
    
    init(path: String) {
        self.path = path
    }
    
    func write(_ text: String) {
        try! text.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
