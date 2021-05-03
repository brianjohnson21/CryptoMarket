//
//  PortfolioCellProtocol.swift
//  CryptoMarket
//
//  Created by Thomas on 30/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation

internal enum CellModelType: String {
    case InputCell
    case DateCell
}

internal protocol PortfolioCellProtocol {
    var type: CellModelType { get }
}

internal final class InputCell: PortfolioCellProtocol {
    var title: String
    
    var type: CellModelType {
        return .InputCell
    }
    
    init(title: String) {
        self.title = title
    }
}

internal final class DateCell: PortfolioCellProtocol {
    var title: String
    
    var type: CellModelType {
        return .DateCell
    }
    
    init(title: String) {
        self.title = title
    }
}

internal final class ContentPortfolioCell: PortfolioCellProtocol {
    var title: String
    
    var type: CellModelType {
        .InputCell
    }
    
    init(title: String) {
        self.title = title
    }
}
