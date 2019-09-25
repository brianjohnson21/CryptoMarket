//
//  MarketNewsViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 16/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift

class MarketNewsViewController: UIViewController {
    
    // private MARK: Members
    private let viewModel: MarketNewsViewModel = MarketNewsViewModel()
    private let disposeBag = DisposeBag()
    private var collectionViewDataSource: [String] = []
    
    // MARK: Outlets
    @IBOutlet private weak var collectionViewNews: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.collectionViewNews.register(MarketNewCell.nib, forCellWithReuseIdentifier: MarketNewCell.identifier)
        self.collectionViewNews.delegate = self
        self.collectionViewNews.dataSource = self
        
        self.title = "Market news"
    }
    
    private func setupViewModel() {
        
        let input = MarketNewsViewModel.Input()
        let output = self.viewModel.transform(input: input)
        
        output.collectionViewDataSource.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (collectionViewDataSource) in
                self.collectionViewDataSource = collectionViewDataSource
                self.collectionViewNews.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
    }

}

extension MarketNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketNewCell.identifier, for: indexPath) as? MarketNewCell {
            cell.title = self.collectionViewDataSource[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension MarketNewsViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
