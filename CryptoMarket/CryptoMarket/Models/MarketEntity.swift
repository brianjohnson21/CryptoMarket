//
//  MarketEntity.swift
//  CryptoMarket
//
//  Created by Thomas on 13/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import ObjectMapper

struct Market: Mappable {
    var id: String?
    var rank: Int?
    var symbol: String?
    var name: String?
    var supply: String?
    var maxSupply: String?
    var marketCapUsd: String?
    var volumeUsd24Hr: String?
    var priceUsd: String?
    var changePercent24Hr: String?
    var vwap24Hr: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        rank <- map["rank"]
        symbol <- map["symbol"]
        name <- map["name"]
        supply <- map["supply"]
        maxSupply <- map["maxSupply"]
        marketCapUsd <- map["marketCapUsd"]
        volumeUsd24Hr <- map["volumeUsd24Hr"]
        priceUsd <- map["priceUsd"]
        changePercent24Hr <- map["changePercent24Hr"]
        vwap24Hr <- map["vwap24Hr"]
    }
    
}
