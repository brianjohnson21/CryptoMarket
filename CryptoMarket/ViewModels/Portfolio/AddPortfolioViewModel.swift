//
//  AddPortfolioViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 29/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal class AddPortfolioViewModel: ViewModelType {
    
    private let onCryptoItemSelected: BehaviorSubject<(Market, Int)> = BehaviorSubject<(Market, Int)>(value: (Market(with: "Bitcoin", and: "BTC"), 0))
    private let onMoneyItemSelected: BehaviorSubject<(MoneyModel, Int)> = BehaviorSubject<(MoneyModel, Int)>(value: (MoneyModel(name: .EURO, amount: 10, isSelected: true), 0))
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let onCryptoCellTapEvent: PublishSubject<Int> = PublishSubject<Int>()
    private let onMoneyCellTapEvent: PublishSubject<Int> = PublishSubject<Int>()
    
    private let isFormValid: PublishSubject<Bool> = PublishSubject<Bool>()
    private let onCellValue: BehaviorSubject<[Int: Double]> = BehaviorSubject<[Int: Double]>(value: [:])
    
    struct Input {
        let doneEvent: Observable<Void>
    }
    
    struct Output {
        let onCryptoItemSelected: Observable<(Market, Int)>
        let onMoneyItemSelected: Observable<(MoneyModel, Int)>
        
        let onCryptoSelectEvent: Observable<Int>
        let onMoneySelectEvent: Observable<Int>
        let tableviewDataSources: Observable<[Int: [PortfolioCellProtocol]]>

        let isFormValid: Observable<Bool>
    }
    
    private func createInputOnCellPortfolio() -> [Int: [PortfolioCellProtocol]] {
        
        var tableViewInput: [PortfolioCellProtocol] = []
        var tableViewDate: [PortfolioCellProtocol] = []
        
        var dataTableView: [Int: [PortfolioCellProtocol]] = [:]
        
        tableViewInput.append(InputCell(title: "Amount", button: nil, isCrypto: true))
        tableViewInput.append(InputCell(title: "Price", button: nil, isCrypto: false))
        tableViewInput.append(InputCell(title: "Total", button: nil, isCrypto: false))
        tableViewInput.append(InputCell(title: "Fee", button: nil, isCrypto: false))
        
        tableViewDate.append(DateCell(title: "Date"))
        
        dataTableView[0] = tableViewInput
        dataTableView[1] = tableViewDate
        
        return dataTableView
    }
    
    internal func onValueSet(with value: (Int, Double)) {
        let cellsValues = try? self.onCellValue.value()
        if var item = cellsValues {
            item[value.0] = value.1
            self.onCellValue.onNext(item)
        }
    }
    
    internal func onCryptoCellEvent(with event: Market, with row: Int) {
        self.onCryptoItemSelected.onNext((event, row))
    }
    
    internal func onMoneyCellEvent(with event: MoneyModel, with row: Int) {
        self.onMoneyItemSelected.onNext((event, row))
    }
    
    internal func onSelectCryptoEvent(row selected: Int) {
        self.onCryptoCellTapEvent.onNext(selected)
    }
    
    internal func onSelectMoneyEvent(row selected: Int) {
        self.onMoneyCellTapEvent.onNext(selected)
    }

    private func createNewPortfolio() {
        guard let cryptoItem = try? self.onCryptoItemSelected.value(),
              let moneyItem = try? self.onMoneyItemSelected.value(),
              let amountValues = try? self.onCellValue.value() else { return }
        
        print(cryptoItem, moneyItem, amountValues)
        
        let newPortfolio = Portfolio(name: cryptoItem.0.name ?? "", id: cryptoItem.0.id, amount: <#T##String#>, symbol: <#T##String#>, date: <#T##Date#>, currentPrice: <#T##String#>)
        
        CoreDataManager.sharedInstance.create(with: Portfolio(name: "", id: "", amount: "", symbol: "", date: Date(), currentPrice: ""))
        
        Portfolio(name: "", id: "", amount: "", symbol: "", date: Date(), currentPrice: "")
        
        print("CRYPTO = \(try? self.onCryptoItemSelected.value())")
        print("CRYPTO = \(try? self.onMoneyItemSelected.value())")
        
        print("AMOUNT = \(try? self.onCellValue.value())")
        
        print("** DONE **")
    }
    
    func transform(input: Input) -> Output {
        let tableViewSource = self.createInputOnCellPortfolio()
        
        
        let cellResultsValues = self.onCellValue.map {
            return $0.values.map { $0 > 0.0 }.filter { $0 == false }.count == 0 && $0.count > 3
        }
        
        let doneTrigger = Observable.combineLatest(input.doneEvent, self.onCellValue).map { return $0.1.count > 3}
        
        let resultFormValidation = Observable.merge(cellResultsValues, doneTrigger)
        
        input.doneEvent.subscribe(onNext: { _ in
            self.createNewPortfolio()
        }).disposed(by: self.disposeBag)
                
        return Output(onCryptoItemSelected: self.onCryptoItemSelected.asObservable(),
                      onMoneyItemSelected: self.onMoneyItemSelected.asObservable(),
                      onCryptoSelectEvent: self.onCryptoCellTapEvent.asObservable(),
                      onMoneySelectEvent: self.onMoneyCellTapEvent.asObservable(),
                      tableviewDataSources: Driver.just(tableViewSource).asObservable(),
                      isFormValid: resultFormValidation.asObservable())
    }
}
