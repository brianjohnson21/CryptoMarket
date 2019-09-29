//
//  MarketNewsEntity.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 29/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import ObjectMapper

public struct MarketNews: ImmutableMappable {
    public let id: String?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?
    
    public init(map: Map) throws {
        self.id = (try? map.value("id")) ?? ""
        self.author = (try? map.value("author")) ?? ""
        self.title = (try? map.value("title")) ?? ""
        self.description = (try? map.value("description")) ?? ""
        self.url = (try? map.value("url")) ?? ""
        self.urlToImage = (try? map.value("urlToImage")) ?? ""
        self.publishedAt = (try? map.value("publishedAt")) ?? ""
        self.content = (try? map.value("content")) ?? ""
    }
}

extension MarketNews: Equatable {
    public static func == (lhs: MarketNews, rhs: MarketNews) -> Bool {
        return lhs.id == rhs.id
    }
}
