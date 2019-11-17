//
//  MarketInformationViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class MarketInformationViewController: UIViewController {

    @IBOutlet private weak var downImage: UIImageView!
    @IBOutlet private weak var upImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage.fontAwesomeIcon(name: .sortUp, style: .solid, textColor: .green, size: CGSize(width: 20, height: 20))
//        self.upImage.image = logo
//        self.upImage.contentMode = .center
//        self.upImage.clipsToBounds = true

        
        let mainImage = logo
        var mainImageView = UIImageView(image:mainImage)
        mainImageView.center = self.upImage.center
        mainImageView.contentMode = .scaleAspectFit
        self.upImage.addSubview(mainImageView)
        
        
        self.downImage.image = UIImage.fontAwesomeIcon(name: .sortDown, style: .solid, textColor: .red, size: CGSize(width: 20, height: 20))
        self.downImage.contentMode = .center
        
    }

}
