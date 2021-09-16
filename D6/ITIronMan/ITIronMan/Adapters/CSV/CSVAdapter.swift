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
