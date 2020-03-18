//
//  NetworkHistory.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 17/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

internal final class NetworkHistory {
    
    public init() { }
    
    public func getHistory(stringUrl url: String, assetName name: String, legendData: MarketHistoryRequest) -> Observable<[MarketInformation]> {
        
        let interval = "/history?interval="
            .concat(string: "\(legendData.interval)")
            .concat(string: "&start=")
            .concat(string: legendData.startDate)
            .concat(string: "&end=")
            .concat(string: legendData.endDate)
        
        return RxAlamofire
            .json(.get, url.concat(string: name).concat(string: interval))
            .retry(2)
            .observeOn(MainScheduler.asyncInstance)
            .map({json -> [MarketInformation] in
                return try Mapper<MarketInformation>().mapArray(JSONObject: ((json as? [String: Any])?["data"] as? [[String: Any]] ?? []))
            })
    }
}
