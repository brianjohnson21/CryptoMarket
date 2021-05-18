//
//  PortfolioViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class PortfolioViewModel: ViewModelType {
    private let isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    private let portfolioValue: BehaviorSubject<Double> = BehaviorSubject<Double>(value: 0.0)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let onDelete: Observable<PortfolioCore>
    }
    
    struct Output {
        let portfolioDataSources: Observable<[PortfolioCore]>
        let isLoading: Observable<Bool>
        let portfolioOnChange: Observable<PortfolioCore>
        let portfolioCurrentValue: Observable<Double>
    }
    
    init() { }
    
    private func fetchPortfolio() -> Observable<[PortfolioCore]> {
        return CoreDataManager.sharedInstance.fetch()
    }
    
    private func onChangePortfolio() -> Observable<PortfolioCore> {
        return CoreDataManager.sharedInstance.getCurrentElement()
    }
    
    private func deletePortfolio(portfolioElement elem: PortfolioCore) {
        do {
            try CoreDataManager.sharedInstance.delete(portfolio: elem)
        } catch {
            print("could not delete \(elem)")
        }
    }
    
    private func fetchCurrentMarket(market name: String) -> Observable<Market> {
        let route = ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)
        return Network.sharedInstance.performGetOnMarket(stringUrl: route, with: name).do(onNext: { _ in
            self.isLoading.onNext(false)
        })
    }
    
    internal func onCryptoAddEvent(with event: Market) {
        print("This has been added!!! \(event)")
    }
    
    private func singleUpdatePortfolio(price: Market, amount: PortfolioCore) -> Double {
        let a = Double(amount.amount ?? "") ?? 0.0
        let v = Double(price.priceUsd ?? "") ?? 0.0
        return v * a
    }
    
    func transform(input: Input) -> Output {
        
        self.isLoading.onNext(true)
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .flatMap({ (core) -> Observable<(Observable<Market>, PortfolioCore)> in
                return Driver.just((self.fetchCurrentMarket(market: core.marketName ?? ""), core)).asObservable()
            }).map({ (rhs, lhs) -> PortfolioCore in
                self.portfolioValue.onNext(0.0)
                return lhs
            }).subscribe {
                self.deletePortfolio(portfolioElement: $0)
            }.disposed(by: self.disposeBag)
        
        let portfolio = self.fetchPortfolio()
            .flatMap { (core: Observable<[PortfolioCore]>.E) -> Observable<(Observable<[Market]>.E, Observable<[PortfolioCore]>.E)> in
                let obs = core.map { (core) -> Observable<Market> in
                    return self.fetchCurrentMarket(market: core.marketName ?? "")
                }
                return Observable.combineLatest(Observable.combineLatest(obs).asObservable(), Driver.just(core).asObservable()).asObservable()
            }.map { (rhs, lhs) -> [PortfolioCore] in
                var portfolioValue = 0.0
                for (e1, e2) in zip(rhs, lhs) {
                    let amount = Double(e2.amount ?? "") ?? 0.0
                    let value = Double(e1.priceUsd ?? "") ?? 0.0
                    portfolioValue += value * amount
                }
                self.portfolioValue.onNext(portfolioValue)
                return lhs
            }.do(onNext: { _ in self.isLoading.onNext(false) })

        
        let onNewElemCreated: Observable<PortfolioCore> = self.onChangePortfolio()
            .flatMap({ (core) -> Observable<PortfolioCore> in
                return Driver.just(core).asObservable()
            })
            .flatMap ({ (core) -> Observable<(Market, PortfolioCore)> in
                let a: Observable<PortfolioCore> = Observable.just(core)
                let b: Observable<Market> = self.fetchCurrentMarket(market: core.marketName ?? "")
                return Observable.zip(b, a) { ($0, $1) }.asObservable()
            }).map { (rhs, lhs) -> PortfolioCore in
                self.portfolioValue.onNext(self.singleUpdatePortfolio(price: rhs, amount: lhs))
                return lhs
            }
            
        
        self.isLoading.onNext(false)
        
        return Output(portfolioDataSources: portfolio,
                      isLoading: self.isLoading.asObservable(),
                      portfolioOnChange: onNewElemCreated.asObservable(),
                      portfolioCurrentValue: self.portfolioValue.asObservable())
    }
}
