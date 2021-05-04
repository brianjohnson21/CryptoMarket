//
//  AddInputTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 29/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddInputTableViewCell: UITableViewCell {

    @IBOutlet private weak var buttonName: UIButton!
    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var amountInput: UITextField!
    private var viewModel: AddInputViewModel? = nil
    private var rowSelected: Int? = 0
    private let onTapEvent: PublishSubject<Int> = PublishSubject<Int>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public var amountDisplay: String? {
        get { return self.amountLabel.text }
        set { self.amountLabel.text = newValue }
    }
    
    public var amountSet: String? {
        get { return self.amountInput.text }
        set { self.amountInput.text = newValue }
    }
    
    internal func setButtonName(with name: String) {
        self.buttonName.setTitle(name, for: .normal)
    }
    
    internal func setup(with controllerPresenting: UIViewController, with vm: AddPortfolioViewModel, with row: Int) {
        self.viewModel = AddInputViewModel(vm: vm)
        self.rowSelected = row
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let input = AddInputViewModel.Input(onTap: self.onTapEvent.asObservable())
        
        let output = self.viewModel?.transform(input: input)
        
        print(output)
    }
    
    @IBAction private func onSelectItem(_ sender: UIButton) {
        self.onTapEvent.onNext(self.rowSelected ?? 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
