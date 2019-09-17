//
//  MarketTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 10/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MarketTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    //MARK: Private Members
    private let viewModel: MarketCellViewModel = MarketCellViewModel()
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public var title: String? {
        set {
          self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }

    public var symbol: String? {
        set {
            self.symbolLabel.text = newValue
        }
        get {
            return self.symbolLabel.text
        }
    }
    
    public var index: String? {
        set {
            self.indexLabel.text = newValue
        }
        get {
            return self.indexLabel.text
        }
    }
    
    public var logoImage: UIImage? {
        set {
            self.imageView?.image = newValue
        }
        get {
            return self.imageView?.image
        }
    }
    
    public var price: String? {
        set {
            self.priceLabel.text = newValue
        }
        get {
            return self.priceLabel.text
        }
    }
    
    public func testLoadingImage(name: String) {
        
        let imageUrl = ApiRoute.ROUTE_IMAGE.concat(string: name).concat(string: ".png")
        print("*** Download image here -> \(imageUrl) ***")
        let input = MarketCellViewModel.Input(imageName: Driver.just(imageUrl))
                
        let output = self.viewModel.transform(input: input)
        
        output.imageDownloaded.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                guard let image = image else  { return }
                self.logoImage = image
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
