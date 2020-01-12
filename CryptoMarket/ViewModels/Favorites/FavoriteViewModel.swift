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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let onDelete: Observable<Favorite>
    }
    
    init() { }
    
    struct Output {
        let favoriteMarket: Observable<[Favorite]>
        let isLoading: Observable<Bool>
        let favoriteOnChange: Observable<Favorite>
    }

    private func fetchFavorites() -> Observable<[Favorite]> {
        return CoreDataManager.sharedInstance.fetch()
    }
    
    private func fetchFavorite() -> Observable<Favorite> {
        return CoreDataManager.sharedInstance.getCurrentElement()
    }
    
    private func deleteFavorite(favoriteElement fav: Favorite) {
        do {
            try CoreDataManager.sharedInstance.delete(fav: fav)
        }catch {
            print("could not delete \(fav)")
        }
    }
    
    ///todo check subscribe here
    func transform(input: Input) -> Output {
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (favDelete) in
                self.deleteFavorite(favoriteElement: favDelete)
            }).disposed(by: self.disposeBag)
        
        let favoriteMarket = self.fetchFavorites()
        
        let newElement = self.fetchFavorite()
    
        return Output(favoriteMarket: favoriteMarket,
                      isLoading: self.isLoading.asObservable(),
                      favoriteOnChange: newElement)
    }
}
