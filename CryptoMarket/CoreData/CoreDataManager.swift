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
    
    private let coreDataContainer: NSPersistentContainer
    private let favOnChange: PublishSubject<Favorite> = PublishSubject<Favorite>()
    
    private var context: NSManagedObjectContext {
        return self.coreDataContainer.viewContext
    }
    
    private init() {
        self.coreDataContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private func fetchData() -> [Favorite] {
        do {
            let favorites = try self.context.fetch(Favorite.fetchRequest() as NSFetchRequest<Favorite>)
            return favorites
        }
        catch {
            return []
        }
    }
    
    public func create(with market: Market) {
        let fav = Favorite(context: self.context)
        
        fav.id = market.id
        fav.name = market.name
        fav.changePercent24Hr = market.changePercent24Hr
        fav.marketCapUsd = market.marketCapUsd
        fav.maxSupply = market.maxSupply
        fav.priceUsd = market.priceUsd
        fav.rank = market.rank
        do {
            self.context.insert(fav)
            try self.context.save()
            self.favOnChange.onNext(fav)
            
        } catch {
            //todo handle
        }
    }
    
    public func getCurrentElement() -> Observable<Favorite> {
        return self.favOnChange.asObservable()
    }
    
    public func fetch() -> Observable<[Favorite]> {
        return Observable<[Favorite]>.create { (observer) -> Disposable in
            observer.onNext(self.fetchData())
            return Disposables.create()
        }
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
