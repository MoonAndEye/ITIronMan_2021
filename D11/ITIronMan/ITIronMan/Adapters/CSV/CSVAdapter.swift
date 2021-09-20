//
//  CSVAdapter.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/3.
//

import Foundation
import SwiftCSV

struct CSVAdapter {
    
    var header = [String]()
    var namedRows = [[String: String]]()
    var namedColumns = [String: [String]]()
    
    init?(rawString: String) {
        
        if let csv = try? CSV(string: rawString) {
            self.header = csv.header
            self.namedRows = csv.namedRows
            self.namedColumns = csv.namedColumns
        }
    }
}

extension CSVAdapter {
    
    /// 在公開資訊站拿到的 csv 檔中，是有一些檔案的 headers 不是從 line = 0開始，而是 line = 1 或其他行，用這個方以去掉
    static func removeLine(_ rawString: String, at line: Int, separator: String = "\n") -> String {
        
        let separatedString = rawString.components(separatedBy: separator)

        let removedString = separatedString.suffix(from: line)
        
        let joinedString = removedString.joined(separator: separator)
        
        return joinedString
    }
}
