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
    
    struct Input {
    }
    
    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    struct Output {
        let favoriteMarket: Observable<[Favorite]>
        let isLoading: Observable<Bool>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
         return Network.sharedInstance.performGetOnMarket(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)).do(onNext: { (market) in
             self.isLoading.onNext(false)
         })
     }
    
    private func fetchFavoriteData() -> Observable<[Favorite]> {
        let favoriteRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            return Observable.just(try self.managedObjectContext.fetch(favoriteRequest))
        } catch {
            print("Could not fetch any data request \(error.localizedDescription)")
        }
        return Observable.just([Favorite()])
    }
    
    func transform(input: Input) -> Output {
        
        let favoriteMarket = self.fetchFavoriteData()
        
        return Output(favoriteMarket: favoriteMarket,
                      isLoading: self.isLoading.asObservable())
    }
}
