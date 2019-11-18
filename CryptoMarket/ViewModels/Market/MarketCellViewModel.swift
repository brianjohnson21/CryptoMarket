//
//  MarketCellViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 16/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class MarketCellViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    private let isLogoLoading = PublishSubject<Bool>()
    
    struct Input {
        let imageName: Driver<String>
    }
    struct Output {
        let imageDownloaded: Observable<UIImage?>
        let isImageLoading: Observable<Bool>
    }
    
    private func fetchImageFromString(pathImage name: String) -> Observable<UIImage?> {
        return Network.sharedInstance.performGetRequestImage(imageUrl: name)
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.imageName.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .do(onNext: { (image) in
            self.isLogoLoading.onNext(true)
        }).flatMapLatest({ (imageName) -> Observable<UIImage?> in
            return self.fetchImageFromString(pathImage: imageName)
        }).do(onNext: { (image) in
            self.isLogoLoading.onNext(false)
        })
        
        return Output(imageDownloaded: result, isImageLoading: self.isLogoLoading)
    }
}
