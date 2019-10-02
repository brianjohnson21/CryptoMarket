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
    private var collectionViewDataSource: [MarketNews] = []
    private let collectionSpinner = UIActivityIndicatorView(style: .whiteLarge)
    
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
    
        self.view.addSubview(self.collectionSpinner)
        self.collectionSpinner.translatesAutoresizingMaskIntoConstraints = false
        self.collectionSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.collectionSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.collectionSpinner.isHidden = false
        self.collectionSpinner.startAnimating()
        self.navigationItem.title = "Market news"
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
        
        output.isLoading.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (isLoading) in
            self.collectionViewNews.isHidden = isLoading
            self.collectionSpinner.isHidden = !isLoading
            isLoading ? self.collectionSpinner.startAnimating() : self.collectionSpinner.stopAnimating()
        }).disposed(by: self.disposeBag)
        

    }


}

extension MarketNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 3) / 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketNewCell.identifier, for: indexPath) as? MarketNewCell {
            cell.title = self.collectionViewDataSource[indexPath.row].title
            cell.content = self.collectionViewDataSource[indexPath.row].content
            cell.loadImageOnCell(urlImage: self.collectionViewDataSource[indexPath.row].urlToImage ?? "")
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
