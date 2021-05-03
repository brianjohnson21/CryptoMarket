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

    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: AddPortfolioViewModel = AddPortfolioViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    private var tableviewDataSources: [Int: [PortfolioCellProtocol]] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupTableView()
        self.setupViewModel()
    }
    
    @IBAction private func cancelTrigger(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func doneTrigger(_ sender: UIBarButtonItem) {
        
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
    }
    
    internal func setup() {
        print("setup")
    }

}

extension AddPortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableviewDataSources[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.tableviewDataSources[indexPath.section]
        if let source = data?[indexPath.row] as? InputCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddInputTableViewCell.identifier, for: indexPath) as? AddInputTableViewCell {
                
                cell.setup(with: self)
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
