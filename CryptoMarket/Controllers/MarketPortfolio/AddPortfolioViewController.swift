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
    private var tableviewDataSources: [String] = []
        
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
        
    }
    
    private func setupViewModel() {
        
    }
    
    internal func setup() {
        print("setup")
    }

}
