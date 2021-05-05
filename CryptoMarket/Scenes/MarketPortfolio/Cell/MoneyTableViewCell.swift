//
//  MoneyTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 04/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoneyTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var isCheckImage: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    private let disposeBag = DisposeBag()
    private var rowSelected: Int = 0
    private var selectItem: MoneyModel = MoneyModel(name: .USD, amount: 1000.0, isSelected: true)
    private var viewModel: AddMoneyCellViewModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal var title: String? {
        set { self.labelTitle.text = newValue }
        get { self.labelTitle.text }
    }
    
    internal var amount: String? {
        set { self.amountLabel.text = newValue }
        get { self.amountLabel.text }
    }
    
    internal func setup(with vm: AddMoneyViewModel, and item: MoneyModel, and row: Int) {
        self.selectItem = item
        self.rowSelected = row
        self.viewModel = AddMoneyCellViewModel(vm: vm)
        self.setupViewModel()
    }
    
    internal func isImageCheck(with value: Bool) {
        self.isCheckImage.isHidden = !value
    }
    
    private func setupViewModel() {
        let input = AddMoneyCellViewModel.Input(onTap: self.rx.tapGesture()
                                                    .filter { $0.state == .ended }.asObservable().map { (_) -> (MoneyModel, Int) in
                                                        return (self.selectItem, self.rowSelected)
                                                    })
        _ = self.viewModel?.transform(input: input)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    internal static var identifier: String {
        return String(describing: self)
    }
    
    internal static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: .main)
    }
}
