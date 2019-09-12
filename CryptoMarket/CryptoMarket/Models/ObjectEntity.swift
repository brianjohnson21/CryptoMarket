//
//  ObjectEntity.swift
//  CryptoMarket
//
//  Created by Thomas on 12/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import ObjectMapper

struct ObjectEntity: Mappable {
    var id: Int?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
