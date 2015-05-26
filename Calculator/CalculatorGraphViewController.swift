//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by Marco Marchini on 20/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import UIKit

class CalculatorGraphViewController: UIViewController, GraphViewDataSource {
    
    // Model
    private var brain = CalculatorBrain()
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get { return brain.program }
        set { brain.program = newValue }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "move:"))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: "moveOrigin:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
        }
    }

    func yForX(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGFloat(y)
        } else {
            return nil
        }
    }
}
