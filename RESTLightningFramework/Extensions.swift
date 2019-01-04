//
//  Extensions.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

// =======================================
//
//               Extensions
//
// =======================================
import Foundation

public extension Data {
    public func hexString() -> String {
        return reduce("") { $0 + String(format: "%02x", UInt8($1)) }
    }
}

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func timeInterval() -> String {
        let timeInterval = TimeInterval(self)
        if let interval = timeInterval {
            let date = Date(timeIntervalSince1970: interval)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return "No Best Header Timestamp"
        }
    }
}
