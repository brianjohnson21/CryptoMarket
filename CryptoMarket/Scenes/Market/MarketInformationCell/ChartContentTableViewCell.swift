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
    @IBOutlet private weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: method called outisde to setup the view
    public func setup(data: String) {
        self.name.text = data
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension ChartContentTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("**![TODO]! handle page **")
    }
}
