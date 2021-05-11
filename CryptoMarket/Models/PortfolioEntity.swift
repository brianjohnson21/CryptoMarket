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
    
    public init(amount: String, price: String, total: String, fee: String,
                date: Date, marketName: String, marketSymbol: String, marketRank: String, id: String) {
        self.amount = amount
        self.price = price
        self.total = total
        self.fee = fee
        self.date = date
        self.marketName = marketName
        self.marketSymbol = marketSymbol
        self.marketRank = marketRank
        self.id = id
    }
    
    public init(portfolio: PortfolioCore) {
        self.id = portfolio.id ?? ""
        self.amount = portfolio.amount ?? ""
        self.price = portfolio.price ?? ""
        self.total = portfolio.total ?? ""
        self.fee = portfolio.fee ?? ""
        self.date = portfolio.date ?? Date()
        self.marketName = portfolio.marketName ?? ""
        self.marketSymbol = portfolio.marketSymbol ?? ""
        self.marketRank = portfolio.marketRank ?? ""
    }
    
    public init (map: Map) throws {
        self.id = (try? map.value("id")) ?? ""
        self.amount = (try? map.value("amount")) ?? ""
        self.price = (try? map.value("price")) ?? ""
        self.total = (try? map.value("total")) ?? ""
        self.fee = (try? map.value("fee")) ?? ""
        self.date = (try? map.value("date")) ?? Date()
        self.marketName = (try? map.value("marketName")) ?? ""
        self.marketSymbol = (try? map.value("marketSymbol")) ?? ""
        self.marketRank = (try? map.value("marketRank")) ?? ""
    }
}

extension Portfolio: Equatable {
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        return lhs.id == rhs.id
    }
}
