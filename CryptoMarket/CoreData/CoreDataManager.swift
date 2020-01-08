//
//  CoreDataManager.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

internal final class CoreDataManager {
    
    public static let sharedInstance = CoreDataManager()
    
    private let coreDataContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private var context: NSManagedObjectContext {
        return self.coreDataContainer.viewContext
    }
    
    private init() { }
    
    public func create(with market: Market) throws {
        let fav = Favorite(context: self.context)
        
        fav.id = market.id
        fav.name = market.name
        fav.changePercent24Hr = market.changePercent24Hr
        fav.marketCapUsd = market.marketCapUsd
        fav.maxSupply = market.maxSupply
        fav.priceUsd = market.priceUsd
        fav.rank = market.rank
        
        self.context.insert(fav)
        try self.context.save()
    }
    
    public func fetch() throws -> Observable<[Favorite]> {
        let favorites = try self.context.fetch(Favorite.fetchRequest() as NSFetchRequest<Favorite>)
        
        let result = Observable<[Favorite]>.create { (observer) -> Disposable in
            observer.onNext(favorites)
            return Disposables.create()
        }
        return result
    }
    
    public func delete(fav: Favorite) throws {
        self.context.delete(fav)
        try self.context.save()
    }
    
    public func delete(with id: String) throws {
        let fetchRequest = Favorite.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try self.context.execute(deleteRequest)
        try self.context.save()
    }
}
