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


class MarketController: UIViewController {
    
    // private MARK: Members
    
    // private MARK: Members
    private let viewModel: MarketViewModel = MarketViewModel()
    private let disposeBag = DisposeBag()
    private var tableViewDataSource: [Market] = []
    private let spinner = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    
    // MARK: Outlets
    @IBOutlet private weak var tableViewMarket: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setupView()
        self.setUpViewModel()
    }
    
    private func setupView() {
        self.tableViewMarket.register(MarketTableViewCell.nib, forCellReuseIdentifier: MarketTableViewCell.identifier)
        self.tableViewMarket.delegate = self
        self.tableViewMarket.dataSource = self
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        self.spinner.isHidden = false
        self.tableViewMarket.backgroundColor = UIColor.black
        self.tableViewMarket.addSubview(refreshControl)
    }
    
    private func setUpViewModel() {
        let input = MarketViewModel.Input(loaderTrigger: self.refreshControl.rx.controlEvent(.valueChanged).asObservable().map { _ in !self.refreshControl.isRefreshing }.filter{ $0 == false }.asObservable())
        
        let output = self.viewModel.transform(input: input)
    
        output.isLoading.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (isLoading) in
                self.spinner.isHidden = !isLoading
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
      
        
        output.tableViewDataSource.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (tableViewDataSource) in
                self.tableViewDataSource = tableViewDataSource
                self.tableViewMarket.reloadData()
                self.refreshControl.endRefreshing()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
    }
}


extension MarketController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
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
            return cell
        }
        return UITableViewCell()
    }
    
}
