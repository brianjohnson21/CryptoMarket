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

final class Network {
    
    public static let sharedInstance = Network()
        
    public func perfromGetRequest(stringUrl url: String) -> Observable<[Market]> {
        
        return RxAlamofire
            .json(.get, url)
            .retry(2)
            .observeOn(MainScheduler.asyncInstance)
            .map({ json -> [Market] in
                return try Mapper<Market>().mapArray(JSONObject: ((json as? [String: Any])?["data"] as? [[String: Any]]) ?? [])
            })
    }
}
