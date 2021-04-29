//
//  PortfolioViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PortfolioViewController: UIViewController {

    @IBOutlet private weak var tableViewPortfolio: UITableView!
    
    private let viewModel: PortfolioViewModel = PortfolioViewModel()
    private let onDelete: PublishSubject<PortfolioCore> = PublishSubject<PortfolioCore>()
    private let disposeBag = DisposeBag()
    private var tableViewDataSource: [PortfolioCore] = []
    private let tableViewSpinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.navigationItem.title = "0.00$"
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
        self.view.addSubview(self.tableViewSpinner)
        self.tableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.tableViewSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.tableViewSpinner.isHidden = false
        self.tableViewSpinner.startAnimating()
        
        let addButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(self.addPortfolio))
        addButton.tintColor = UIColor.init(named: "WhiteImage")
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    private func setupTableView() {
        self.tableViewPortfolio.register(PortfolioTableViewCell.nib, forCellReuseIdentifier: PortfolioTableViewCell.identifier)
        self.tableViewPortfolio.delegate = self
        self.tableViewPortfolio.dataSource = self
    }
    
    @objc private func addPortfolio() {
        
        if let vc = UIStoryboard(name: "PortfolioStoryboard", bundle: .main).instantiateViewController(withIdentifier: "AddPortfolioViewStoryboard") as? AddPortfolioViewController {
            vc.setup()
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
    private func setupViewModel() {
        let input = PortfolioViewModel.Input(onDelete: self.onDelete.asObservable())
        let output = self.viewModel.transform(input: input)
        
        output.portfolioDataSources.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (dataSource) in
                self.tableViewDataSource = dataSource
                self.tableViewPortfolio.reloadData()
            }).disposed(by: self.disposeBag)

        output.portfolioOnChange.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe { (element) in
                self.tableView(new: element)
            }.disposed(by: self.disposeBag)
        
        output.isLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (isLoading) in
                self.tableViewPortfolio.isHidden = isLoading
                self.tableViewSpinner.isHidden = !isLoading
                isLoading ? self.tableViewSpinner.startAnimating() : self.tableViewSpinner.stopAnimating()
            }).disposed(by: self.disposeBag)
        
        output.portfolioCurrentValue.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { portfolioValue in
                self.navigationItem.title = "$\(portfolioValue)"
            }).disposed(by: self.disposeBag)
    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func tableView(new element: PortfolioCore) {
        self.tableViewDataSource.append(element)
        let selectedIndexPath = IndexPath(row: self.tableViewDataSource.count - 1, section: 0)
        self.tableViewPortfolio.beginUpdates()
        self.tableViewPortfolio.insertRows(at: [selectedIndexPath], with: .automatic)
        self.tableViewPortfolio.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteElem = tableViewDataSource[indexPath.row]
            self.onDelete.onNext(deleteElem)
            self.tableView(removeElement: deleteElem, indexPath: indexPath)
        }
    }
    
    private func tableView(removeElement element: PortfolioCore, indexPath: IndexPath) {
        self.tableViewDataSource.remove(at: indexPath.row)
        self.tableViewPortfolio.beginUpdates()
        self.tableViewPortfolio.deleteRows(at: [indexPath], with: .automatic)
        self.tableViewPortfolio.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioTableViewCell.identifier, for: indexPath) as? PortfolioTableViewCell {
            cell.index = self.tableViewDataSource[indexPath.row].id
            cell.title = self.tableViewDataSource[indexPath.row].name
            cell.symbol = self.tableViewDataSource[indexPath.row].symbol
            cell.price = self.tableViewDataSource[indexPath.row].currentPrice
            cell.loadImageOnCell(name: self.tableViewDataSource[indexPath.row].name?.lowercased() ?? "")
            cell.setSelectedBackgroundColor(selectedColor: UIColor.init(named: "SecondColor") ?? .white)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
}
