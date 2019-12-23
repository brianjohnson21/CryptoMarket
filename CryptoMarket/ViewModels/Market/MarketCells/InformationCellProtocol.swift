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
    //type of the cell that needs to be displayed
    var type: CellViewModelType { get }
    //used as the title of a section, doesn't necessary have one..
    var title: String? { get }
    
    //todo row?
}

internal final class ChartCell: CellViewModelProtocol {
    var title: String?

    var type: CellViewModelType {
        return .Chart
    }
    
    init(title: String?) {
        self.title = title
    }
}

internal final class InformationCell: CellViewModelProtocol {
    var title: String?
    var isOpen: Bool
    var items: [Int: (String, String)]
    
    var type: CellViewModelType {
        return .Detail
    }
    
    init(title: String?, items: [Int: (String, String)], isOpen: Bool) {
        self.title = title
        self.isOpen = isOpen
        self.items = items
    }
}
