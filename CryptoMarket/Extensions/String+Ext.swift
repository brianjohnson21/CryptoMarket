//
//  String+Ext.swift
//  CryptoMarket
//
//  Created by Thomas on 12/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation

extension String {
    func concat(string: String) -> String{
        return "\(self)\(string)"
    }
    
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func percentageFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str.concat(string: " %")
            }
        }
        return ""
    }
}
