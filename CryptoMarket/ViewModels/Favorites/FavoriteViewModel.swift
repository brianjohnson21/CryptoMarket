//
//  FavoriteViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 05/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

internal final class FavoriteViewModel: ViewModelType {
    
    private let isLoading = PublishSubject<Bool>()
    var managedObjectContext: NSManagedObjectContext!
    
    struct Input { }
    
    init() { }
    
    struct Output {
        let favoriteMarket: Observable<[Favorite]>
        let isLoading: Observable<Bool>
    }

    private func fetchFavoriteData() -> Observable<[Favorite]> {
        return CoreDataManager.sharedInstance.fetch()
    }
    
    func transform(input: Input) -> Output {
        
        let favoriteMarket = self.fetchFavoriteData()
    
        return Output(favoriteMarket: favoriteMarket,
                      isLoading: self.isLoading.asObservable())
    }
}
