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
    
    private func getUrl(index: Int) -> String {
        switch index {
        case 0:
        return "https://raw.githubusercontent.com/Mthomas3/cryptocurrency-logos/master/coins/128x128/bitcoin.png"
        case 1:
        return "https://raw.githubusercontent.com/Mthomas3/cryptocurrency-logos/master/coins/64x64/bitcoin.png"
        case 2:
        return "https://raw.githubusercontent.com/Mthomas3/cryptocurrency-logos/master/coins/32x32/bitcoin.png"
        case 3:
        return "https://raw.githubusercontent.com/Mthomas3/cryptocurrency-logos/master/coins/16x16/bitcoin.png"
        default:
            return "https://cryptologos.cc/logos/thumbs/bitcoin.png"
        }
        
    }
    
    public func testLoadingImage(name: String, index: Int) {
        
        var imageUrl = ApiRoute.ROUTE_IMAGE.concat(string: name).concat(string: ".png")
        
        imageUrl = self.getUrl(index: index)
        print(imageUrl)
        let input = MarketCellViewModel.Input(imageName: Driver.just(imageUrl))

        let output = self.viewModel.transform(input: input)
        
        output.imageDownloaded.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                guard let image = image else  { return }
                self.logoImage = image.scaleImage(toSize: CGSize(width: 15, height: 15))
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


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}


extension UIImageView {

   func setRounded() {
    let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
