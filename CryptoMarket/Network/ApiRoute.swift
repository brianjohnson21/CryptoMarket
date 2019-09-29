//
//  ApiRoute.swift
//  CryptoMarket
//
//  Created by Thomas on 12/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation

public enum ApiRoute {
    
    public static let ROUTE_SERVER_MARKET = "https://api.coincap.io/v2/"
    public static let ROUTE_MARKET = "assets"
    public static let ROUTE_IMAGE = "https://cryptologos.cc/logos/thumbs/"
    
    public static let ROUTE_SERVER_NEWS = "https://newsapi.org/v2/everything?q="
    public static let ROUTE_NEWS_CRYPTOCURRENCY = "Cryptocurrency&from=2019-09-29&sortBy=popularity&apiKey="
    
}
