//
//  MarketNewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 24/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class MarketNewCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet private weak var newImage: UIImageView!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageViewLoader: UIActivityIndicatorView!
    
    //MARK: Members
    private let viewModel: MarketNewsCellViewModel = MarketNewsCellViewModel()
    private let disposeBag = DisposeBag()
    
    public var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    public var image: UIImage? {
        set {
            self.newImage.image = newValue
        }
        get {
            return self.newImage.image
        }
    }
    
    public var content: String? {
        set {
            self.contentLabel.text = newValue
        }
        get {
            return self.contentLabel.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.numberOfLines = 2
        self.imageViewLoader.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    private var imageUrlString: String?
    
    public func loadImageOnCell(urlImage name: String) {
        let input = MarketNewsCellViewModel.Input(imageName: Driver.just(name))
        
        self.imageUrlString = name
        
        let output = self.viewModel.transform(input: input)
        self.newImage.image = nil
        
        if let imageFromCache = self.imageCache.object(forKey: name as AnyObject) as? UIImage {
            
            self.image = imageFromCache
        } else {
            
            
            
            output.imageDownloaded.asObservable()
                .subscribeOn(MainScheduler.asyncInstance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (imageView) in
                    guard let image = imageView else { return }
                    let imageToCache = image
                    if self.imageUrlString == name {
                        self.image = imageToCache
                    }
                    self.imageCache.setObject(imageToCache, forKey: name as AnyObject)
                }).disposed(by: self.disposeBag)
            
            
            output.isImageLoading.asObservable()
                .subscribeOn(MainScheduler.asyncInstance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (isLoading) in
                    self.newImage.isHidden = isLoading
                    self.imageViewLoader.isHidden = !isLoading
                    isLoading ? self.imageViewLoader.startAnimating() : self.imageViewLoader.stopAnimating()
                }).disposed(by: self.disposeBag)
        }
        
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
