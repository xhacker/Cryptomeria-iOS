//
//  BorderedButton.swift
//  Cryptomeria
//
//  Created by Dongyuan Liu on 2015-10-05.
//  Copyright © 2015 Xhacker. All rights reserved.
//

import UIKit

class TopBottomBorderedButton: UIButton {
    
    let topBorderView = UIView()
    let bottomBorderView = UIView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(topBorderView)
        addSubview(bottomBorderView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBorderView.frame = CGRect(x: 0, y: 0.5, width: frame.size.width + 1, height: 1)
        topBorderView.backgroundColor = tintColor

        bottomBorderView.frame = CGRect(x: 0, y: frame.size.height - 0.5, width: frame.size.width + 1, height: 1)
        bottomBorderView.backgroundColor = tintColor
    }

}

class RoundedButton: UIButton {
    let borderLayer = CAShapeLayer()
    var roundingCorners: UIRectCorner = []
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                let color = tintColor.withAlphaComponent(0.15)
                borderLayer.fillColor = color.cgColor
            }
            else {
                borderLayer.fillColor = UIColor.clear.cgColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
        
        super.init(coder: aDecoder)
        
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pathBounds = CGRect(x: 0.5, y: 1, width: bounds.width - 1, height: bounds.height - 1)
        let path = UIBezierPath(roundedRect: pathBounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 3, height: 3))
        borderLayer.frame = bounds
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = tintColor.cgColor
    }

}

class LeftRoundedButton: RoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        roundingCorners = [.topLeft, .bottomLeft]
    }
}

class RightRoundedButton: RoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        roundingCorners = [.topRight, .bottomRight]
    }
}
