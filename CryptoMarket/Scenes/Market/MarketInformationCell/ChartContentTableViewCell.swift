//
//  ChartContentTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 07/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit

class ChartContentTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerScrollView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension ChartContentTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("**![TODO]! handle page **")
    }
}
