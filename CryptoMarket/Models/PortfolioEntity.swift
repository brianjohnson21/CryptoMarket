//
//  Portfolio.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct Portfolio {
    let amount: String
    let price: String
    let total: String
    let fee: String
    let date: Date
    let marketName: String
    let marketSymbol: String
    let marketRank: String
    let id: String
}

extension Portfolio: Equatable {
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        return lhs.id == rhs.id
    }
}
