//
//  ChartContentTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 07/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChartContentTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerScrollView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var name: UILabel!
    
    private var viewModel: ContentChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    private let scrollViewDataSource: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupScrollViewForCharts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: method called outisde to setup the view
    public func setup(data: String) {
        self.name.text = data
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension ChartContentTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    private func setupScrollViewForCharts() {
        self.scrollView.delegate = self
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.containerScrollView.frame.width, height: self.containerScrollView.frame.height)
        //todo size
        
        let size = 2
        self.scrollView.contentSize = CGSize(width: self.containerScrollView.frame.width * CGFloat(size), height: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }
}
