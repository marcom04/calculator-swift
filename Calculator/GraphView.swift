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
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 1 { didSet { setNeedsDisplay() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        origin = convertPoint(center, fromView: superview)      // default origin to superview's center
    }
    
    override func drawRect(rect: CGRect) {
        let axesDrawer = AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
    }
    
    // --- Gestures handlers
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            origin.x += translation.x
            origin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func moveOrigin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
}
