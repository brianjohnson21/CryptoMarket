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
    public let isLoading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let onDelete: Observable<PortfolioCore>
    }
    
    struct Output {
        let portfolioDataSources: Observable<[PortfolioCore]>
        let isLoading: Observable<Bool>
        let portfolioOnChange: Observable<PortfolioCore>
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
    
    func transform(input: Input) -> Output {
        self.isLoading.onNext(true)
        
        input.onDelete
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe {
                self.deletePortfolio(portfolioElement: $0)
            }.disposed(by: self.disposeBag)
        
        let portfolio = self.fetchPortfolio().do(onNext: { _ in self.isLoading.onNext(false) })
        
        let newElem = self.onChangePortfolio()
        
        self.isLoading.onNext(false)
        return Output(portfolioDataSources: portfolio,
                      isLoading: self.isLoading.asObservable(),
                      portfolioOnChange: newElem)
    }
}
