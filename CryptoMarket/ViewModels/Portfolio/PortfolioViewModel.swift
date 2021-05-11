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
    
    internal func onCryptoAddEvent(with event: Market) {
        print("This has been added!!! \(event)")
    }
    
    func transform(input: Input) -> Output {
        self.isLoading.onNext(true)
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe {
                self.deletePortfolio(portfolioElement: $0)
            }.disposed(by: self.disposeBag)
        
        let portfolio = self.fetchPortfolio().do(onNext: { _ in self.isLoading.onNext(false) })
        
        let portfolioValue = portfolio.map { (portfolio) -> Double in
            return portfolio.map { (item: PortfolioCore) in
                print(item.amount)
                return ((item.amount ?? "0.0") as? Double ?? 0.0)
            }.reduce(0, +)
        }
        
        let newElem = self.onChangePortfolio()
        
        self.isLoading.onNext(false)
        return Output(portfolioDataSources: portfolio,
                      isLoading: self.isLoading.asObservable(),
                      portfolioOnChange: newElem,
                      portfolioCurrentValue: portfolioValue.asObservable())
    }
}
