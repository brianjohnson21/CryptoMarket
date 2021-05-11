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
    
    internal func onCryptoAddEvent(with event: Market) {
        print("This has been added!!! \(event)")
    }
    
    func transform(input: Input) -> Output {
        self.isLoading.onNext(true)
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .map {
                let current = (try? self.portfolioValue.value()) ?? 0.0
                let removeValue = Double($0.amount ?? "0.0") ?? 0.0
                self.portfolioValue.onNext(current - removeValue)
                return $0
            }.subscribe {
                self.deletePortfolio(portfolioElement: $0)
            }.disposed(by: self.disposeBag)
        
        let portfolio = self.fetchPortfolio()
            .do(onNext: { _ in self.isLoading.onNext(false) })
            .do(onNext: { val in
                self.portfolioValue.onNext(val.map { return (Double($0.amount ?? "0.0") ?? 0.0) }.reduce(0, +))
            })
        
        let newElem = self.onChangePortfolio()
            .do(onNext: { elem in
                let current = (try? self.portfolioValue.value()) ?? 0.0
                let newValue = Double(elem.amount ?? "0.0") ?? 0.0
                self.portfolioValue.onNext(current + newValue)
            })
        
        self.isLoading.onNext(false)
        
        return Output(portfolioDataSources: portfolio,
                      isLoading: self.isLoading.asObservable(),
                      portfolioOnChange: newElem,
                      portfolioCurrentValue: self.portfolioValue.asObservable())
    }
}
