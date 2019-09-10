//
//  AddMarketController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift

class AddMarketController: UIViewController {

    // MARK: Members
    private let viewModel: AddMarketViewModel = AddMarketViewModel()
    private let disposeBag = DisposeBag()
    private var tableViewDataSource = []
    
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    private func setUpView() {
        self.title = "Add a new Cryptocurrency"
    }
    
}

extension AddMarketController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
