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
    private var tableViewDataSource: [String] = [""]
    
    // MARK: Outlets
    @IBOutlet private weak var tableViewMarket: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setUpViewModel()
    }
    
    private func setupView() {
        self.tableViewMarket.register(MarketTableViewCell.nib, forCellReuseIdentifier: MarketTableViewCell.identifier)
        self.tableViewMarket.delegate = self
        self.tableViewMarket.dataSource = self
    }
    
    private func setUpViewModel() {
        
        let input = MarketViewModel.Input()
        
        let output = self.viewModel.transform(input: input)
        
        output.tableViewDataSource.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (tableViewDataSource) in
                self.tableViewDataSource = tableViewDataSource
                self.tableViewMarket.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.identifier, for: indexPath) as? MarketTableViewCell {
            cell.title = tableViewDataSource[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
