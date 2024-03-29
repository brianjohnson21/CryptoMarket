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
    
    public var imageCache = NSCache<AnyObject, AnyObject>()
    private var currentUrl: String?
    
    struct Input {
        let imageName: Driver<String>
    }
    
    struct Output {
        let imageDownloaded: Observable<UIImage?>
        let isImageLoading: Observable<Bool>
    }
    
    init() {
        self.imageCache.totalCostLimit = 500_000_000
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
    
    public func getImageOnCache(key name: String) -> UIImage? {
        return self.imageCache.object(forKey: name as AnyObject) as? UIImage
    }
    
    public func saveImageOnCache(image: UIImage, key name: String) {
        self.imageCache.setObject(image, forKey: name as AnyObject)
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.imageName.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (image) in
                self.isLoading.onNext(true)
            }).flatMap { (imageName) -> Observable<UIImage?> in
                return self.fetchImageFromString(pathImage: imageName)
            }.do(onNext: { (image) in
                self.isLoading.onNext(false)
            })
    
        return Output(imageDownloaded: result, isImageLoading: self.isLoading)
    }
}

