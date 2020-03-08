//
//  MarketEmotion.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct MarketEmotion: ImmutableMappable {
    public let value: String?
    public let value_classification: String?
    public let timestamp: String?
    public let time_until_update: String?
    
    public init(map: Map) throws {
        self.value = (try? map.value("value") ?? "")
        self.value_classification = (try? map.value("value_classification") ?? "")
        self.timestamp = (try? map.value("timestamp") ?? "")
        self.time_until_update = (try? map.value("time_until_update") ?? "")
    }
}
