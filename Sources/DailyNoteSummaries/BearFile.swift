//
//  BearFile.swift
//  DailyNoteSummaries
//
//  Created by Dylan Elliott on 1/10/20.
//

import Foundation

class BearFile: File {
    var id: String? {
        if let contents = self.contents {
            let match = idRegex.firstMatch(in: contents)
            let matchString = match?.string(forGroup: 1, in: contents)
            return matchString
        } else {
            return nil
        }
    }
    
    let idRegex = try! NSRegularExpression(pattern: "<!-- \\{BearID:(.+)\\} -->")
    
    let title: String
    let tags: [String]
    
    required init(title: String, path: String, tags: [String] = []) {
        self.title = title
        self.tags = tags
        super.init(path: path)
    }
    
    override func write(_ text: String) {
        var contents = """
        # \(title)
        
        \(text)
        """
        
        if tags.isEmpty == false {
            contents += "\n\n\(tags.map { "#\($0)" }.joined(separator: " "))"
        }
        
        if let id = id {
            contents += "\n\n<!-- {BearID:\(id)} -->"
        }
        
        super.write(contents)
    }
}
