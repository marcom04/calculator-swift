//
//  GraphView.swift
//  Calculator
//
//  Created by Marco Marchini on 20/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView
{
    var origin: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var scale: CGFloat = 1
    
    override func drawRect(rect: CGRect) {
        let axesDrawer = AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
    }
}
