//
//  MarketNewsViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 16/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class MarketNewsViewController: UIViewController {
    
    //MARK: Members
    private let viewModel: MarketNewsViewModel = MarketNewsViewModel()
    private let disposeBag = DisposeBag()
    private var collectionViewDataSource: [MarketNews] = []
    private let collectionSpinner = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    
    //MARK: Outlets
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
        
        self.collectionViewNews.refreshControl = refreshControl
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationItem.title = "Market news"
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
    }

    private func setupViewModel() {
            
        let input = MarketNewsViewModel.Input(
            loaderTrigger: self.refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .map { _ in !self.refreshControl.isRefreshing }
                .filter { $0 == false })
        
        let output = self.viewModel.transform(input: input)

        output.collectionViewDataSource
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (collectionViewDataSource) in
                self.collectionViewDataSource = collectionViewDataSource
                self.collectionViewNews.reloadData()
                self.collectionViewNews.refreshControl?.endRefreshing()
            }, onError: { (error) in
                self.handleErrorOnRetry(error: error, message: ErrorMessage.errorMessageNews) {
                    self.setupViewModel()
            }
        }).disposed(by: self.disposeBag)
  
        output.isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageUrl = self.collectionViewDataSource[indexPath.row].url else { return }
        if let url = URL(string: imageUrl) {
            let config = SFSafariViewController.Configuration()
            
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.preferredBarTintColor = UIColor.black
            vc.preferredControlTintColor = UIColor.systemBlue
            
            self.present(vc, animated: true)
        }
    }
}

extension MarketNewsViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
