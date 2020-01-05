//
//  MarketFavoritesViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 21/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MarketFavoritesViewController: UIViewController {
    
    //MARK: Members
    private let tableViewDataSource: [Market] = []
    private let disposeBag = DisposeBag()
    private let viewModel: FavoriteViewModel = FavoriteViewModel()
    

    //MARK: Outlets
    @IBOutlet private weak var tableViewFavorite: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.navigationItem.title = "Favorites"
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
    }
    
    private func setupTableView() {
        self.tableViewFavorite.register(MarketTableViewCell.nib, forCellReuseIdentifier:   MarketTableViewCell.identifier)
        self.tableViewFavorite.delegate = self
        self.tableViewFavorite.dataSource = self
    }
    
    private func setupViewModel() {
        let input = FavoriteViewModel.Input()
        let output = self.viewModel.transform(input: input)
        
    }
}

extension MarketFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
