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

final class Network {
    
    public static let sharedInstance = Network()
    private let alamofireManager = SessionManager.default
    
    private func getHeadersNetwork() -> [String: String] {
        let headers = ["Authorization": ""]
        
        return headers
    }
    
    public func performPostRequest(stringUrl url: String) {}
    
    public func performGetRequest(stringUrl url: String) -> Observable<DataRequest> {
        return RxAlamofire.request(.get, url)
        .asObservable()
    }
}
