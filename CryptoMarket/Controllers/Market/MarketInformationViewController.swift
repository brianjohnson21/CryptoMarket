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
import SwiftEntryKit
import Lottie

class MarketInformationViewController: UIViewController {

    //MARK: Members
    private var viewModel: MarketInformationViewModel!
    private let disposeBag = DisposeBag()
    private var tableViewDataSource = [CellViewModelProtocol]()
    private let favoriteEvent: PublishSubject<Void> = PublishSubject()
    
    private var selectedMarket: Market?
    private var selectedMarketIcon: UIImage?
    private var flowType: MarketInformationFlowType = .market
    
    //MARK: Outlets
    @IBOutlet private weak var tableViewInformation: UITableView!
    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupNavigationTitle(with navigationIcon: UIImage) {
  
        let navigationTitleView: NavigationTitleView = NavigationTitleView.fromNib()
        navigationTitleView.setup(title: "\(self.selectedMarket?.name ?? "")", icon: navigationIcon)
        self.navigationItem.titleView = navigationTitleView
        self.navigationItem.titleView?.sizeToFit()
    }
    
    private func displayFavoriteAlert() {
        AnimationPopup.displayAnimation(with: "\(self.selectedMarket?.name ?? "") Added to your favorite.", and: selectedMarketIcon ?? UIImage())
    }
    
    @IBAction private func favoriteTrigger(_ sender: UIButton) {
        self.animationView.play()
        self.favoriteEvent.onNext(())
        self.displayFavoriteAlert()
    }
    
    private func setupView() {
        self.favoriteButton.isEnabled = self.flowType == .market ? true : false
        
        //todo change title tableview
        self.tableViewInformation.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.identifier)
        self.tableViewInformation.register(HeaderInformationTableViewCell.nib, forCellReuseIdentifier: HeaderInformationTableViewCell.identifier)
        self.tableViewInformation.register(ChartContentTableViewCell.nib, forCellReuseIdentifier: ChartContentTableViewCell.identifier)
        
        self.tableViewInformation.delegate = self
        self.tableViewInformation.dataSource = self
        
        self.setupViewAnimation()
    }
    
    private func setupViewAnimation() {
        self.animationView.animation = Animation.named("heartAnimation")
        self.animationView.animationSpeed = 10.0
        self.animationView.play()
        self.animationView.animationSpeed = 2.0
    }
        
    private func setupViewModel() {
        let input = MarketInformationViewModel.Input(
            favoriteEvent: self.favoriteEvent.asObservable())
        
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
    
    public func setup(marketSelected: Market, with type: MarketInformationFlowType,
                      navigationMarketIcon: UIImage) {
        self.selectedMarket = marketSelected
        self.flowType = type
        self.selectedMarketIcon = navigationMarketIcon
        
        self.viewModel = MarketInformationViewModel(marketSelected: marketSelected)
        self.setupNavigationTitle(with: navigationMarketIcon)
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
        if let item = tableViewDataSource[indexPath.row] as? ChartContentCell {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChartContentTableViewCell.identifier, for: indexPath) as? ChartContentTableViewCell {
                cell.setup(lineChartMarket: item.lineChart?.market)
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
