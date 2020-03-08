//
//  PieChart.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class PieChart: UIView {
    
    @IBOutlet private weak var pieChart: PieChart!
    
    private var viewModel: PieChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //method called outside to setup
    public func setup() {
        self.viewModel = PieChartViewModel()
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() { }
    
    private func setupViewModel() {
        let input = PieChartViewModel.Input()
        
        let output = self.viewModel.transform(input: input)
        
        print(output)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
