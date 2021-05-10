//
//  Animation+Ext.swift
//  CryptoMarket
//
//  Created by Thomas on 10/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit
import SwiftEntryKit

struct AnimationPopup {
    
    static func displayAnimation(with content: String, and image: UIImage?) {
        let style = EKProperty.LabelStyle(
            font: .boldSystemFont(ofSize: 16),
            color: .white,
            alignment: .center)
        
        let labelContent = EKProperty.LabelContent(
                   text: "\(content)",
                   style: style)
        
        let image = EKProperty.ImageContent(
            image: image ?? UIImage(),
            size: (image != nil) ? CGSize(width: 25, height: 25) : CGSize(width: 0, height: 0))
    
        let contentView = EKImageNoteMessageView(
              with: labelContent,
              imageContent: image)
        
        contentView.set(.height, of: 60)
        
        let topColor = UIColor.init(named: "Color-3") ?? UIColor.black
        let bottomColor = UIColor.init(named: "Color") ?? UIColor.black
        var attributes: EKAttributes = .bottomFloat
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [EKColor.init(light: topColor, dark: topColor), EKColor.init(light: bottomColor, dark: bottomColor)],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)))
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
