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
    
    private func getFavorites() -> Observable<[Favorite]> {
        return CoreDataManager.sharedInstance.fetch()
    }
    
    private func getMarket() -> Observable<[Market]> {
        return Network.sharedInstance.performGetOnMarket(stringUrl:
            ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET))
    }
    
    ///todo check subscribe here
    func transform(input: Input) -> Output {
        
        self.isLoading.onNext(true)
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (favDelete) in
                self.deleteFavorite(favoriteElement: favDelete)
            }).disposed(by: self.disposeBag)
    
        let favorites = self.getFavorites().do(onNext: { _ in self.isLoading.onNext(false) })
        
        let newElement = self.fetchFavorite()
    
        return Output(favoriteMarket: favorites,
                      isLoading: self.isLoading.asObservable(),
                      favoriteOnChange: newElement)
    }
}
