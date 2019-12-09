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
    
    //MARK: Outlets
    @IBOutlet private weak var tableViewInformation: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        
        //todo change title tableview
        self.tableViewInformation.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.identifier)
        self.tableViewInformation.register(ChartTableViewCell.nib, forCellReuseIdentifier: ChartTableViewCell.identifier)
        
        self.tableViewInformation.delegate = self
        self.tableViewInformation.dataSource = self
    }
    
    private func setupViewModel() {
        let input = MarketInformationViewModel.Input()
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
    
    func createChartCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        if let item = tableViewDataSource[indexPath.row] as? ChartCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as? ChartTableViewCell {
                //cell.price = item.title
                //cell.percentage = item.detail
                
                cell.price = "$9000.09"
                cell.percentage = "1.59%"
                
                cell.setupChart()
                
                cell.setSelectedBackgroundColor(selectedColor: UIColor.clear)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func createMarketInformationsCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        if let item = tableViewDataSource[indexPath.row] as? InformationCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as? InformationTableViewCell {
                cell.title = item.title
                cell.detail = item.detail
                cell.setSelectedBackgroundColor(selectedColor: UIColor.init(named: "SecondColor") ?? .white)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCell = tableViewDataSource[indexPath.row]
        switch  currentCell.type{
        case .Detail:
            return 50.0
        case .Chart:
            return 320.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableViewDataSource[indexPath.row]
        switch currentCell.type {
        case .Detail:
            return createMarketInformationsCell(indexPath: indexPath, tableView: tableView)
        case .Chart:
            return createChartCell(indexPath: indexPath, tableView: tableView)
        }
    }
}
