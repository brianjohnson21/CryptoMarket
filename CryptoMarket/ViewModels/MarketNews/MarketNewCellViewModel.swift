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

public final class MarketNewsCellViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let imageName: Driver<String>
    }
    struct Output {
        let imageDownloaded: Observable<UIImage?>
    }
    
    private func fetchImageFromString(pathImage name: String) -> Observable<UIImage?> {
        return Network.sharedInstance.performGetRequestImage(imageUrl: name)
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.imageName.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .flatMap { (imageName) -> Observable<UIImage?> in
                return self.fetchImageFromString(pathImage: imageName)
            }
        
        return Output(imageDownloaded: result)
    }
}
