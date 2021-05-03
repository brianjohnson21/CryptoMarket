//
//  AddCryptoTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 03/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddCryptoTableViewCell: UITableViewCell {

    @IBOutlet private weak var imageDisplay: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var shortTitle: UILabel!
    
    private let viewModel: MarketCellViewModel = MarketCellViewModel()
    private let disposeBag = DisposeBag()
    private let spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func setup() {
        
    }
    
    internal var name: String? {
        get { return self.title.text }
        set { self.title.text = newValue }
    }
    
    internal var shortName: String? {
        get { return self.shortTitle.text }
        set { self.shortTitle.text = newValue }
    }
    
    internal func loadImage(with name: String) {
        print("Loading ** \(name)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal static var identifier: String {
        return String(describing: self)
    }
    
    internal static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: .main)
    }
    
}
