## 🚀 Welcome to CryptoMarket! 🚀

CryptoMarket is an app to see the current Market of cryptocurrencies 📊. 
The idea of the app was to play around with [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel) and [RxSwift](https://github.com/ReactiveX/RxSwift) on iOS 

For now, it is still a **BETA!**, not all bugs have been found yet (please report any you encounter).

### 👀 Usage

This project uses Cocoapods to manage the decencies. If you want to run the project, your first need to install the pods by doing pod install.
An API key is required and you can add your own **newsapi** key by using [cocoapods keys](https://github.com/orta/cocoapods-keys). 
TMP
First install it by doing `gem install cocoapods-keys` and then add your keys and like this:

<pre>$ pod keys set MarketNewsAPIClient YOUR_API_KEY </pre>

### 🔨  Architecture

[MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel) is use throughout the app, as well as [Reactive Programming](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) with [RxSwift](https://github.com/ReactiveX/RxSwift)

All `ViewModels` expose [RxSwift](https://github.com/ReactiveX/RxSwift) observables in the form of [Drivers](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Units.md) that are perfect to use in `ViewModels` because they:
* Can't error out.
* Observe occurs on main scheduler.
* Shares side effects (share(replay: 1, scope: .whileConnected)).

`ViewControllers` can later connect to this drivers and update UI Elements, for example:

```swift
    let output = self.viewModel.transform(input: ViewModel.Input())

    output.Label
        .bind(to: self.titleLabel.rx.text)
        .disposed(by: self.disposeBag)
```    
`ViewControllers` can later connect to observables as well, for example:

```swift
    let output = self.viewModel.transform(input: ViewModel.Input())  
  
    output.collectionViewDataSource.asObservable()
        .observeOn(MainScheduler.instance)
        .subscribeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { (collectionViewDataSource) in
            self.collectionViewDataSource = collectionViewDataSource
            self.collectionViewNews.reloadData()
        }, onError: { (error) in
            self.handlePlanningError(error: error)
        }).disposed(by: self.disposeBag)
```

### ⚠ Disclaimer 

### ⚙️ Contributing

You’re more than welcome to improve and add new features to the app! I will create a backlog soon.

### 👽 Author

I’m Thomas Martins, [ThomasMartins](https://www.linkedin.com/in/thomas-martins-0343b1b7/)

### Release


### 📝 License

`CryptoMarket` is released under the MIT License. See [LICENSE](https://github.com/pixel16/CountItApp/blob/master/LICENSE) for details. 
