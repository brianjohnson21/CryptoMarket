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
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var logoLoader: UIActivityIndicatorView!
    @IBOutlet weak var changePercent: UILabel!
    
    //MARK: Private Members
    private let viewModel: MarketCellViewModel = MarketCellViewModel()
    private let disposeBag = DisposeBag()
    private let spinner = UIActivityIndicatorView(style: .white)

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
            self.labelName.text = newValue
        }
        get {
            return self.labelName.text
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
            self.imageLogo?.image = newValue
        }
        get {
            return self.imageLogo?.image
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

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageLogo.image = nil
    }
    
    public func loadImageOnCell(name: String) {
                
        let input = MarketCellViewModel.Input(imageName:
            Driver.just(ApiRoute.ROUTE_IMAGE.concat(string: name).concat(string: ".png")))
        
        let output = self.viewModel.transform(input: input)
        
        output.imageDownloaded.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                guard let image = image else  { return }
                self.logoImage = image
                self.imageLogo.setRounded()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        output.isImageLoading.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (isLoading) in
            self.imageLogo.isHidden = isLoading
            isLoading ? self.logoLoader.startAnimating() : self.logoLoader.stopAnimating()
            self.logoLoader.isHidden = !isLoading
        }).disposed(by: self.disposeBag)
        
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
