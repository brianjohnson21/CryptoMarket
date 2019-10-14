//
//  MarketNewCellViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 29/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
//import Kingfisher need to be removed

public final class MarketNewsCellViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    private let isLoading = PublishSubject<Bool>()
    
    private var imageCache = NSCache<AnyObject, AnyObject>()
    private var currentUrl: String?
    
    struct Input {
        let imageName: Driver<String>
    }
    
    struct Output {
        let imageDownloaded: Observable<UIImage?>
        let isImageLoading: Observable<Bool>
    }
    
    public var currentDownloadUrl: String? {
        set {
            self.currentUrl = newValue
        }
        get {
            return self.currentUrl
        }
    }
    
    private func fetchImageFromString(pathImage name: String) -> Observable<UIImage?> {
        return Network.sharedInstance.performGetRequestImage(imageUrl: name)
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.imageName.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (image) in
                self.isLoading.onNext(true)
            }).flatMap({ (imageName) -> Observable<UIImage?> in
                if let image = self.imageCache.object(forKey: imageName as AnyObject) as? Observable<UIImage?> {
                    return image
                }
                let imageDownloaded = self.fetchImageFromString(pathImage: imageName)
                self.imageCache.setObject(imageDownloaded, forKey: imageName as AnyObject)
                return imageDownloaded
            }).do(onNext: { (image) in
              self.isLoading.onNext(false)
            })
        return Output(imageDownloaded: result, isImageLoading: self.isLoading)
    }
}
