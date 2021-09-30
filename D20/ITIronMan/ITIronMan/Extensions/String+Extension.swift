//
//  String+Extension.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/5.
//

import Foundation

extension String {
    
    static func dataWtihBig5(data: Data) -> Self? {
        
        let big5Encoding = CFStringEncodings.big5_HKSCS_1999.rawValue
        
        let convertEncodingBig5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(big5Encoding))
        
        return String(data: data, encoding: String.Encoding(rawValue: convertEncodingBig5))
    }
}
