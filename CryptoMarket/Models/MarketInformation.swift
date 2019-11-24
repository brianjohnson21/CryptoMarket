//
//  MarketInformation.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct MarketInformation: ImmutableMappable {
    public let priceUsd: String?
    public let time: String?
    public let date: String?
    
    public init(map: Map) throws {
        self.priceUsd = (try? map.value("priceUsd") ?? "")
        self.time = (try? map.value("time") ?? "")
        self.date = (try? map.value("date") ?? "")
    }
}

