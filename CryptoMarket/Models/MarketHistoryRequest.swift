//
//  MarketHistoryRequest.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 04/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation

internal struct MarketHistoryRequest {
    let startDate: String
    let endDate: String
    let interval: ApiInterval
    
    init(startDate start: String, endDate end: String, inteval: ApiInterval) {
        self.startDate = start
        self.endDate = end
        self.interval = inteval
    }
}
