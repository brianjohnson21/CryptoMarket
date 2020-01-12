//
//  MarketEntity.swift
//  CryptoMarket
//
//  Created by Thomas on 13/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct Market: ImmutableMappable  {
    
    public let id: String?
    public let rank: String?
    public let symbol: String?
    public let name: String?
    public let supply: String?
    public let maxSupply: String?
    public let marketCapUsd: String?
    public let volumeUsd24Hr: String?
    public let priceUsd: String?
    public let changePercent24Hr: String?
    public let vwap24Hr: String?
    
    public init(map: Map) throws {
        self.id = (try? map.value("id")) ?? ""
        self.rank = (try? map.value("rank")) ?? ""
        self.symbol = (try? map.value("symbol")) ?? ""
        self.name = (try? map.value("name")) ?? ""
        self.supply = (try? map.value("supply")) ?? ""
        self.maxSupply = (try? map.value("maxSupply")) ?? ""
        self.marketCapUsd = (try? map.value("marketCapUsd")) ?? ""
        self.volumeUsd24Hr = (try? map.value("volumeUsd24Hr")) ?? ""
        self.priceUsd = (try? map.value("priceUsd")) ?? ""
        self.changePercent24Hr = (try? map.value("changePercent24Hr")) ?? ""
        self.vwap24Hr = (try? map.value("vwap24Hr")) ?? ""
    }
    
    public init(with favorite: Favorite) {
        self.id = favorite.id
        self.rank = favorite.rank
        self.symbol = favorite.symbol
        self.name = favorite.name
        self.supply = favorite.supply
        self.maxSupply = favorite.maxSupply
        self.marketCapUsd = favorite.marketCapUsd
        self.volumeUsd24Hr = favorite.volumeUsd24Hr
        self.priceUsd = favorite.priceUsd
        self.changePercent24Hr = favorite.changePercent24Hr
        self.vwap24Hr = favorite.vwap24Hr
    }

}

extension Market: Equatable {
    public static func == (lhs: Market, rhs: Market) -> Bool {
        return lhs.id == rhs.id
    }
}
