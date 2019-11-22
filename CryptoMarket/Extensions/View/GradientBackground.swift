//
//  GradientBackground.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 20/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

@IBDesignable final class SegmentView: UIView {
    
    @IBInspectable var firstColor: String = ""
    @IBInspectable var middleColor: String = ""
    @IBInspectable var lastColor: String = ""
    
       override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
            
        self.backgroundColor = .red
    }
    
}


//func setGradientBackground() {
//    let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//    let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
//
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [colorTop, colorBottom]
//    gradientLayer.locations = [0.0, 1.0]
//    gradientLayer.frame = self.view.bounds
//
//    self.view.layer.insertSublayer(gradientLayer, at:0)
//}
