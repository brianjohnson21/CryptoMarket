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
    private var tableViewDataSource: [Favorite] = []
    private let disposeBag = DisposeBag()
    private let viewModel: FavoriteViewModel = FavoriteViewModel()
    private let onDelete: PublishSubject<Favorite> = PublishSubject<Favorite>()

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
        let input = FavoriteViewModel.Input(onDelete: self.onDelete.asObservable())
        let output = self.viewModel.transform(input: input)
        
        output.favoriteMarket.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (favorite) in
                self.tableViewDataSource = favorite
                self.tableViewFavorite.reloadData()
        }).disposed(by: self.disposeBag)
        
        output.favoriteOnChange.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (element) in
                self.tableView(addNewElement: element)
            }).disposed(by: self.disposeBag)
    }
}

extension MarketFavoritesViewController {
    
    private func tableView(addNewElement element: Favorite) {
        self.tableViewDataSource.append(element)
        let selectedIndexPath = IndexPath(row: self.tableViewDataSource.count - 1, section: 0)
        self.tableViewFavorite.beginUpdates()
        self.tableViewFavorite.insertRows(at: [selectedIndexPath], with: .automatic)
        self.tableViewFavorite.endUpdates()
    }
    
    private func tableView(removeElement element: Favorite, indexPath: IndexPath) {
        self.tableViewDataSource.remove(at: indexPath.row)
        self.tableViewFavorite.beginUpdates()
        self.tableViewFavorite.deleteRows(at: [indexPath], with: .automatic)
        self.tableViewFavorite.endUpdates()
    }
}

extension MarketFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.price = tableViewDataSource[indexPath.row].priceUsd?.currencyFormatting(formatterDigit: 2)
            cell.loadImageOnCell(name: tableViewDataSource[indexPath.row].id ?? "")
            cell.setPercentageOnMarket(percentage: tableViewDataSource[indexPath.row].changePercent24Hr ?? "")
            cell.setSelectedBackgroundColor(selectedColor: UIColor.init(named: "SecondColor") ?? .white)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteElem = tableViewDataSource[indexPath.row]
            self.onDelete.onNext(deleteElem)
            self.tableView(removeElement: deleteElem, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Market", bundle: nil).instantiateViewController(withIdentifier: "MarketInformationStoryboard") as? MarketInformationViewController {
            vc.setup(marketSelected: Market(with: tableViewDataSource[indexPath.row]), with: .favorite)
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
