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

class MarketNewCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet private weak var newImage: UIImageView!
    @IBOutlet private weak var contentLabel: UITextView!
    @IBOutlet private weak var titleLabel: UITextView!
    
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
    }
    
    public func loadImageOnCell(urlImage name: String) {
        let input = MarketNewsCellViewModel.Input(imageName: Driver.just(name))
        
        let output = self.viewModel.transform(input: input)
        
        output.imageDownloaded.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                guard let image = image else { return }
                self.image = image
            }).disposed(by: self.disposeBag)
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
