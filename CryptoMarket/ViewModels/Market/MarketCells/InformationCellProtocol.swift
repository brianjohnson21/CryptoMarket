//
//  InformationCellProtocol.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation

internal enum CellViewModelType: String {
    case Chart
    case Detail
}

internal protocol CellViewModelProtocol {
    var type: CellViewModelType { get }
    var title: String { get }
    var rowCount: Int { get }
}

internal final class ChartCell: CellViewModelProtocol {
    var title: String
    var detail: String
    var type: CellViewModelType {
        return .Chart
    }
    var rowCount: Int { return 1}
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}

internal final class InformationCell: CellViewModelProtocol {
    var title: String
    var detail: String
    var isOpen: Bool
    var items: [String]
    
    var type: CellViewModelType {
        return .Detail
    }
    var rowCount: Int { return items.count }
    
    init(title: String, detail: String, items: [String], isOpen: Bool) {
        self.title = title
        self.isOpen = isOpen
        self.items = items
        self.detail = detail
    }
}
