//
//  AddInputTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 29/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class AddInputTableViewCell: UITableViewCell {

    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var amountInput: UITextField!
    
    private var withControllerPresenting: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public var amountDisplay: String? {
        get { return self.amountLabel.text }
        set { self.amountLabel.text = newValue }
    }
    
    public var amountSet: String? {
        get { return self.amountInput.text }
        set { self.amountInput.text = newValue }
    }
    
    internal func setup(with controllerPresenting: UIViewController) {
        self.withControllerPresenting = controllerPresenting
    }
    
    @IBAction private func onSelectItem(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "PortfolioStoryboard", bundle: .main).instantiateViewController(withIdentifier: "AddCryptoStoryboard") as? AddCryptoViewController {
            self.withControllerPresenting?.present(vc, animated: true, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
