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
    private var tableViewDataSource: [MarketNews] = []
    private let tableViewSpinner = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    
    //MARK: Outlets
    @IBOutlet private weak var tableViewNews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.tableViewNews.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.tableViewNews.delegate = self
        self.tableViewNews.dataSource = self
    
        self.view.addSubview(self.tableViewSpinner)
        self.tableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.tableViewSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.tableViewSpinner.isHidden = false
        self.tableViewSpinner.startAnimating()
        self.refreshControl.tintColor = UIColor.init(named: "White")
        self.tableViewNews.refreshControl = refreshControl
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationItem.title = "News"
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
            .subscribe(onNext: { (tableViewDataSource) in
                self.tableViewDataSource = tableViewDataSource
                self.tableViewNews.reloadData()
                
                //todo remove this
                self.tableViewNews.refreshControl?.endRefreshing()
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
                self.tableViewNews.isHidden = isLoading
                //todo change this name
                self.tableViewSpinner.isHidden = !isLoading
                isLoading ? self.tableViewSpinner.startAnimating() : self.tableViewSpinner.stopAnimating()
            }).disposed(by: self.disposeBag)
    }
}

extension MarketNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell {
            cell.title = self.tableViewDataSource[indexPath.row].title
            cell.date = self.tableViewDataSource[indexPath.row].publishedAt
            cell.loadImageOnCell(urlImage: self.tableViewDataSource[indexPath.row].urlToImage)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

//extension MarketNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (self.view.frame.width - 3) / 1
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.collectionViewDataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketNewCell.identifier, for: indexPath) as? MarketNewCell {
//            cell.title = self.collectionViewDataSource[indexPath.row].title
//            cell.content = self.collectionViewDataSource[indexPath.row].content
//            cell.loadImageOnCell(urlImage: self.collectionViewDataSource[indexPath.row].urlToImage ?? "")
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let imageUrl = self.collectionViewDataSource[indexPath.row].url else { return }
//        if let url = URL(string: imageUrl) {
//            let config = SFSafariViewController.Configuration()
//
//            config.entersReaderIfAvailable = true
//            let vc = SFSafariViewController(url: url, configuration: config)
//            vc.preferredBarTintColor = UIColor.black
//            vc.preferredControlTintColor = UIColor.systemBlue
//
//            self.present(vc, animated: true)
//        }
//    }
//}
