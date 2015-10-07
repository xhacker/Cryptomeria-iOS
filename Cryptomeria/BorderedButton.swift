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
        
        topBorderView.frame = CGRectMake(0, 0.5, frame.size.width + 1, 1)
        topBorderView.backgroundColor = tintColor

        bottomBorderView.frame = CGRectMake(0, frame.size.height - 0.5, frame.size.width + 1, 1)
        bottomBorderView.backgroundColor = tintColor
    }

}

class RoundedButton: UIButton {
    let borderLayer = CAShapeLayer()
    var roundingCorners: UIRectCorner = []
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                let color = tintColor.colorWithAlphaComponent(0.15)
                borderLayer.fillColor = color.CGColor
            }
            else {
                borderLayer.fillColor = UIColor.clearColor().CGColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.lineWidth = 1
        
        super.init(coder: aDecoder)
        
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pathBounds = CGRectMake(0.5, 1, bounds.width - 1, bounds.height - 1)
        let path = UIBezierPath(roundedRect: pathBounds, byRoundingCorners: roundingCorners, cornerRadii: CGSizeMake(3, 3))
        borderLayer.frame = bounds
        borderLayer.path = path.CGPath
        borderLayer.strokeColor = tintColor.CGColor
    }

}

class LeftRoundedButton: RoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        roundingCorners = [.TopLeft, .BottomLeft]
    }
}

class RightRoundedButton: RoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        roundingCorners = [.TopRight, .BottomRight]
    }
}