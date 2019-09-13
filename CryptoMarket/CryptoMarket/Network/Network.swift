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
    private let alamofireManager = SessionManager.default
    
    private func getHeadersNetwork() -> [String: String] {
        let headers = ["Authorization": ""]
        
        return headers
    }
    
    public func perfromGetRequest(stringUrl url: String) -> Observable<[Market]> {
        
        return RxAlamofire
            .json(.get, url, headers: [:])
            .retry(2)
            .debug()
            .observeOn(MainScheduler.asyncInstance)
            .map { (json) -> [Market] in
                
                if let data = (json["data"] as? [[String: Any]]) {
                  print("inside data -> \(data)")
                }
//                let data = Data(json as? [[String: Any]])
//                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
//
//                return try Mapper<Market>().mapArray(JSONArray: data as Any) as! [[String: Any]]
                //return try Mapper<Market>().mapArray(JSONArray: json["data"] as! [String : Any])
                
            }
        }
}
