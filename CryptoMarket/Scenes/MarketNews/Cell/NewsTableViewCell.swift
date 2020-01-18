//
//  NewsTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage
import RxAlamofire

class NewsTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet private weak var titleNews: UILabel!
    @IBOutlet private weak var dateLabelNews: UILabel!
    @IBOutlet private weak var imageNews: UIImageView!
    
    //MARK: Members
    private let viewModel: MarketNewsCellViewModel = MarketNewsCellViewModel()
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageNews.image = UIImage()
    }
    
    private func setupView() {
        self.imageNews.layer.cornerRadius = 10
    }
    
    public var title: String? {
        get {
            return self.titleNews.text
        }
        set {
            self.titleNews.text = newValue
        }
    }
    
    public var date: String? {
        get {
            return self.dateLabelNews.text
        }
        set {
            self.dateLabelNews.text = newValue
        }
    }
    
    public func loadImageOnCell(urlImage: String?) {
        
        //MARK: put a default picture if none
        guard let urlImage = urlImage, !urlImage.isEmpty else { return }
  
        if let image = self.viewModel.imageCache.object(forKey: urlImage as AnyObject) as? UIImage? {
            
            if (image != nil) {
                self.imageNews.image = image
                return
            }
        }
        
        let input = MarketNewsCellViewModel.Input(imageName: Driver.just(urlImage))
        let output = self.viewModel.transform(input: input)
              
        self.viewModel.currentDownloadUrl = urlImage
              
        output.imageDownloaded.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (imageView) in
                guard let image = imageView else { return }
                    if self.viewModel.currentDownloadUrl == urlImage {
                        print("**[4] NEWS TABLE DONE")
                        self.viewModel.saveImageOnCache(image: image, name: urlImage)
                        self.imageNews.image = image
                    }
            }).disposed(by: self.disposeBag)
              
        output.isImageLoading.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (isLoading) in
                self.imageNews.isHidden = isLoading
            }).disposed(by: self.disposeBag)
    }
    
    private func setupViewModel() {
        
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
