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

    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var amountInput: UITextField!
    @IBOutlet private weak var cryptoButton: UIButton!
    @IBOutlet private weak var moneyButton: UIButton!
    
    private var viewModel: AddInputViewModel? = nil
    private var rowSelected: Int? = 0
    private let onSelectCrypto: PublishSubject<Int> = PublishSubject<Int>()
    private let onSelectMoney: PublishSubject<Int> = PublishSubject<Int>()
    
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
    
    internal func setButtonName(with name: String, isCrypto: Bool) {
        isCrypto ? self.cryptoButton.setTitle(name, for: .normal) : self.moneyButton.setTitle(name, for: .normal)
    }
    
    internal func setup(with vm: AddPortfolioViewModel, with row: Int, isCrypto: Bool) {
        self.viewModel = AddInputViewModel(vm: vm)
        self.rowSelected = row
        self.setupViewModel()
        self.cryptoButton.isHidden = !isCrypto
        self.moneyButton.isHidden = isCrypto
    }
    
    private func setupViewModel() {
        let input = AddInputViewModel.Input(onSelectCrypto: self.onSelectCrypto.asObservable(),
                                            onSelectMonyey: self.onSelectMoney.asObservable())
        _ = self.viewModel?.transform(input: input)
    }
    
    @IBAction private func onSelectCrypto(_ sender: UIButton) {
        self.onSelectCrypto.onNext(self.rowSelected ?? 0)
    }
    
    @IBAction private func onSelectUsd(_ sender: UIButton) {
        self.onSelectMoney.onNext(self.rowSelected ?? 0)
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
