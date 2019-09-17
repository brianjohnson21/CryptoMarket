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
    
    struct Input {
        let imageName: Driver<String>
    }
    struct Output {
        let imageDownloaded: Observable<UIImage?>
    }
    
    private func fetchImageFromString(pathImage name: String) -> Observable<UIImage?> {
        return Network.sharedInstance.performDownloadImage(imageUrl: name)
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.imageName.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .flatMapLatest({ (imageName) -> Observable<UIImage?> in
            return self.fetchImageFromString(pathImage: imageName)
        })
        
        return Output(imageDownloaded: result)
    }
}
