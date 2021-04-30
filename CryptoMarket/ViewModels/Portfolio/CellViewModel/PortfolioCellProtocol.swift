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
