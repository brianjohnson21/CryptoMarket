//
//  ViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 05/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import Hero

class MarketController: UIViewController {
        
    // private MARK: Members
    private let viewModel: MarketViewModel = MarketViewModel()
    private let disposeBag = DisposeBag()
    private var tableViewDataSource: [Market] = []
    private let spinner = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    private let quickSearchTextChanged: PublishSubject<String> = PublishSubject<String>()
    
    // MARK: Outlets
    @IBOutlet private weak var tableViewMarket: UITableView!
    @IBOutlet private weak var quickSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setUpViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayTableViewAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableViewMarket.hero.isEnabled = false
        self.view.endEditing(true)
    }
    
    private func setupView() {
        self.navigationItem.title = "Market view"
        self.setupTableView()
        self.setupSpinner()
        self.setupNavbar()
        self.setupSearchController()
    }
    
    private func setupTableView() {
        self.tableViewMarket.isHidden = true
        self.tableViewMarket.register(MarketTableViewCell.nib, forCellReuseIdentifier: MarketTableViewCell.identifier)
        self.tableViewMarket.delegate = self
        self.tableViewMarket.dataSource = self
        self.tableViewMarket.keyboardDismissMode = .onDrag
    }
    
    private func setupSpinner() {
        self.spinner.center = self.view.center
        self.spinner.isHidden = false
        self.view.addSubview(self.spinner)
        self.spinner.startAnimating()
    }
    
    private func setupNavbar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.refreshControl.tintColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.tableViewMarket.refreshControl = self.refreshControl
        self.tableViewMarket.backgroundColor = UIColor.init(named: "MainColor")
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white


        
        self.navigationItem.searchController = searchController
    }
    
    private func displayTableViewAnimation() {
        self.tableViewMarket.hero.isEnabled = true
        self.tableViewMarket.hero.modifiers = [.cascade(delta: 2.0, direction: .bottomToTop, delayMatchedViews: true)]
        for (index, cell) in self.tableViewMarket.visibleCells.enumerated() {
            cell.hero.modifiers = [.duration(0.12 * Double(index)),.translate(CGPoint.init(x: 0, y: 120))]
        }
    }
    
    private func setUpViewModel() {
        let input = MarketViewModel.Input(loaderTrigger:
            self.refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .map { _ in !self.refreshControl.isRefreshing }
            .filter{ $0 == false })
//            quickSearchText: (self.navigationItem.searchController?.searchBar.rx.text.asDriver())!)
        
        let output = self.viewModel.transform(input: input)
        
        output.isLoading
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (isLoading) in
                self.spinner.isHidden = !isLoading
                self.spinner.stopAnimating()
                self.tableViewMarket.isHidden = isLoading
            }).disposed(by: self.disposeBag)
      
        output.tableViewDataSource
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (tableViewDataSource) in
                self.tableViewDataSource = tableViewDataSource
                self.refreshControl.endRefreshing()
                self.tableViewMarket.reloadData()
            }, onError: { (error) in
                self.handleErrorOnRetry(error: error, message: ErrorMessage.errorMessageMarket) {
                    self.setUpViewModel()
                }
            }).disposed(by: self.disposeBag)
        
//        output.quickSearchFound
//            .observeOn(MainScheduler.instance)
//            .subscribeOn(MainScheduler.asyncInstance)
//            .subscribe(onNext: { (searchFound) in
//                self.tableViewDataSource = searchFound
//                self.tableViewMarket.reloadData()
//            }, onError: { (error) in
//                self.handleErrorOnRetry(error: error, message: ErrorMessage.errorMessageMarket) {
//                    self.setUpViewModel()
//                }
//            }).disposed(by: self.disposeBag)
    }
}

extension MarketController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.identifier, for: indexPath) as? MarketTableViewCell {
            cell.title = tableViewDataSource[indexPath.row].name
            cell.symbol = tableViewDataSource[indexPath.row].symbol
            cell.index = tableViewDataSource[indexPath.row].rank
            cell.price = tableViewDataSource[indexPath.row].priceUsd?.currencyFormatting()
            cell.loadImageOnCell(name: tableViewDataSource[indexPath.row].id ?? "")
            cell.setPercentageOnMarket(percentage: tableViewDataSource[indexPath.row].changePercent24Hr ?? "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Item selected -> \(tableViewDataSource[indexPath.row])")
        let vc = UIStoryboard(name: "Market", bundle: nil).instantiateViewController(withIdentifier: "MarketInformationStoryboard")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MarketController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
