//
//  AddPortfolioViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 29/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddPortfolioViewController: UIViewController {
    
    private let viewModel: AddPortfolioViewModel = AddPortfolioViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    private var tableviewDataSources: [Int: [PortfolioCellProtocol]] = [:]
    private var cryptoRowSelected: Int = 0
    private var moneyRowSelected: Int = 0
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction private func cancelTrigger(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func doneTrigger(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupTableView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.navigationItem.title = "Portfolio"
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupTableView() {
        self.tableView.register(AddInputTableViewCell.nib, forCellReuseIdentifier: AddInputTableViewCell.identifier)
        self.tableView.register(AddDateTableViewCell.nib, forCellReuseIdentifier: AddDateTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupViewModel() {
        let input = AddPortfolioViewModel.Input()
        let output = self.viewModel.transform(input: input)
        
        output.tableviewDataSources.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tableViewSource in
                self.tableviewDataSources = tableViewSource
                self.tableView.reloadData()
            }).disposed(by: self.disposeBag)
        
        output.onCryptoItemSelected.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                self.cryptoRowSelected = event.1
                self.updateCryptoEvent(symbol: event.0.symbol ?? "")
            }).disposed(by: self.disposeBag)
        
        output.onMoneyItemSelected.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                self.moneyRowSelected = event.1
                self.updateMoneyEvent(with: event.1, with: event.0)
            }).disposed(by: self.disposeBag)
        
        output.onCryptoSelectEvent.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                if let vc = UIStoryboard(name: "PortfolioStoryboard", bundle: .main).instantiateViewController(withIdentifier: "AddCryptoStoryboard") as? AddCryptoViewController {
                    vc.setup(with: self.viewModel, with: self.cryptoRowSelected)
                    self.present(vc, animated: true)
                }
            }).disposed(by: self.disposeBag)
        
        output.onMoneySelectEvent
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                if let vc = UIStoryboard(name: "PortfolioStoryboard", bundle: .main).instantiateViewController(withIdentifier: "AddMoneyStoryboard") as? AddMoneyViewController {
                    vc.setup(with: self.viewModel, with: self.moneyRowSelected)
                    self.present(vc, animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    internal func setup() { }

}

extension AddPortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableviewDataSources[section]?.count ?? 0
    }
    
    func updateCryptoEvent(symbol name: String) {
        let item = self.tableviewDataSources[0]
        if let source = item?[0] as? InputCell {
            source.buttonName = name
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func updateMoneyEvent(with row: Int, with money: MoneyModel) {
        let item = self.tableviewDataSources[0]
        item?.enumerated().forEach {
            if $0 > 0, let s = $1 as? InputCell {
                s.buttonName = money.name.rawValue
                self.tableView.reloadRows(at: [IndexPath(row: $0, section: 0)], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.tableviewDataSources[indexPath.section]
        if let source = data?[indexPath.row] as? InputCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddInputTableViewCell.identifier, for: indexPath) as? AddInputTableViewCell {
                if let name = source.buttonName {
                    cell.setButtonName(with: name, isCrypto: source.isCrypto)
                }
                cell.setup(with: self.viewModel, with: indexPath.row, isCrypto: source.isCrypto)
                cell.amountDisplay = source.title
                return cell
            }
        } else if let source = data?[indexPath.row] as? DateCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddDateTableViewCell.identifier, for: indexPath) as? AddDateTableViewCell {
                cell.title = source.title
                return cell
            }
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableviewDataSources.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
