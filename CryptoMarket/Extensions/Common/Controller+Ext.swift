//
//  Controller+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func performUIAlert(title: String?, message: String?, actionTitles:[String?], actions:[(UIAlertAction) -> Void]) {
        
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleError(error: Error, message: String) {
        let title = "An error occured"
        let message = message
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
     func handleErrorOnRetry(error: Error, message: String, retry: @escaping() -> ()) {
        let title = "An error occured"
        let message = message
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
            retry()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

