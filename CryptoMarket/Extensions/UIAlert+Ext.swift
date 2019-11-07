//
//  UIAlert+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/10/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlertOnError(error: Error, actionTitles:[String?], actions:[(UIAlertAction) -> Void]) {
        
        let alert =  UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
