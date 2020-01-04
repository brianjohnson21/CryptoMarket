//
//  Date+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 04/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
