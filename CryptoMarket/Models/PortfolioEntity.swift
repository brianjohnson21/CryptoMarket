//
//  Portfolio.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct Portfolio {
    let name: String
    let id: String
    let amount: String
    let symbol: String
    let date: Date
    let currentPrice: String
}

extension Portfolio: Equatable {
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        return lhs.id == rhs.id
    }
}
