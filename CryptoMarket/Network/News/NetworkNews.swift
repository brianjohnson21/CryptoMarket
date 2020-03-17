//
//  NetworkNews.swift
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
import Keys

internal final class NetworkNews {
    
    private let ApiMarketNewsKey: String
    
    public init() {
        let keys = CryptoMarketKeys()
        self.ApiMarketNewsKey = keys.marketNewsAPIClient
    }
    
    public func getNews(stringUrl url: String) -> Observable<[MarketNews]> {
        return RxAlamofire
            .json(.get, url.concat(string: self.ApiMarketNewsKey))
            .retry(2)
            .observeOn(MainScheduler.asyncInstance)
            .map({json -> [MarketNews] in
                return try Mapper<MarketNews>().mapArray(JSONObject: ((json as? [String: Any])?["articles"] as? [[String: Any]]) ?? [])
            })
    }
}
