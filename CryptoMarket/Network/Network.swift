//
//  Network.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 11/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import ObjectMapper
import Keys

final class Network {
    private let ApiMarketNewsKey: String
    
    init() {
        let keys = CryptoMarketKeys()
        self.ApiMarketNewsKey = keys.marketNewsAPIClient
    }
    
    public static let sharedInstance = Network()
    
    //MARK: todo switch to single ->
    public func performGetOnMarket(stringUrl url: String) -> Observable<[Market]> {
        return RxAlamofire
            .json(.get, url)
            .retry(2)
            .observeOn(MainScheduler.asyncInstance)
            .map({ json -> [Market] in
                return try Mapper<Market>().mapArray(JSONObject: ((json as? [String: Any])?["data"] as? [[String: Any]]) ?? [])
        })
    }
    
    public func performGetOnNews(stringUrl url: String) -> Observable<[MarketNews]>{
        return RxAlamofire
            .json(.get, url.concat(string: self.ApiMarketNewsKey))
            .retry(2)
            .observeOn(MainScheduler.asyncInstance)
            .map({json -> [MarketNews] in
                return try Mapper<MarketNews>().mapArray(JSONObject: ((json as? [String: Any])?["articles"] as? [[String: Any]]) ?? [])
            })
    }
    
    public func performGetRequestImage(imageUrl url: String) -> Observable<UIImage?> {
            return RxAlamofire
            .requestData(.get, url)
            .map({ (response,data) -> UIImage? in
                return UIImage(data: data)
            })
    }
}
