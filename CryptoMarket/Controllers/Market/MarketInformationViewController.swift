//
//  MarketInformationViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MarketInformationViewController: UIViewController {

    //MARK: Members
    //TODO: change ->
    private var viewModel: MarketInformationViewModel!
    private let disposeBag = DisposeBag()
    private var tableViewDataSource = [CellViewModelProtocol]()
    private let favoriteEvent: PublishSubject<Void> = PublishSubject()
    
    //MARK: Outlets
    @IBOutlet private weak var tableViewInformation: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupView()
        self.setupViewModel()
    }
    
    
    @IBAction func favoriteItemTrigger(_ sender: UIBarButtonItem) {
        self.favoriteEvent.onNext(())
    }
    
    private func setupView() {
        
        //todo change title tableview
        self.tableViewInformation.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.identifier)
        self.tableViewInformation.register(ChartTableViewCell.nib, forCellReuseIdentifier: ChartTableViewCell.identifier)
        self.tableViewInformation.register(HeaderInformationTableViewCell.nib, forCellReuseIdentifier: HeaderInformationTableViewCell.identifier)
        
        self.tableViewInformation.delegate = self
        self.tableViewInformation.dataSource = self
    }
        
    private func setupViewModel() {
        let input = MarketInformationViewModel.Input(favoriteEvent: self.favoriteEvent.asObservable())
        
        let output = self.viewModel.transform(input: input)
        
        output.tableViewDataSource.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (tableViewDataSource) in
                self.tableViewDataSource = tableViewDataSource
                self.tableViewInformation.reloadData()
            }).disposed(by: self.disposeBag)
        
        self.navigationItem.title = output.navigationTitle
    }
    
    public func setup(marketSelected: Market) {
        self.viewModel = MarketInformationViewModel(marketSelected: marketSelected)
    }

}

extension MarketInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let item = tableViewDataSource[section] as? InformationCell, item.isOpen == true else { return 1 }
        
        return item.items.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableViewDataSource[section].type == .Detail {
            if let cellHeader = tableView.dequeueReusableCell(withIdentifier: HeaderInformationTableViewCell.identifier) as? HeaderInformationTableViewCell {
                
                let titleSection = tableViewDataSource[section]
                cellHeader.title = titleSection.title
                
                return cellHeader
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewDataSource[section].type == .Detail ? 30.0 : 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewDataSource.count
    }
    
    func createChartCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        if let item = tableViewDataSource[indexPath.row] as? ChartCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as? ChartTableViewCell {
                
                //cell.price = item.title
                //cell.percentage = item.detail
                print(item)
                cell.price = "$9000.09"
                cell.percentage = "1.59%"
                
                cell.setupChart()
                
                cell.setSelectedBackgroundColor(selectedColor: UIColor.clear)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.init(named: "MainColor")
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func createMarketInformationsCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        if let item = tableViewDataSource[indexPath.section] as? InformationCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as? InformationTableViewCell {
                
                cell.detail = item.items[indexPath.row]?.0
                cell.title = item.items[indexPath.row]?.1
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCell = tableViewDataSource[indexPath.section]
        switch  currentCell.type{
        case .Detail:
            return 45.0
        case .Chart:
            return 400.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableViewDataSource[indexPath.section]
        switch currentCell.type {
        case .Detail:
            return createMarketInformationsCell(indexPath: indexPath, tableView: tableView)
        case .Chart:
            return createChartCell(indexPath: indexPath, tableView: tableView)
        }
    }
}
