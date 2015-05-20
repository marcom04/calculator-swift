//
//  ViewController.swift
//  Calculator
//
//  Created by Marco Marchini on 08/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    // Optional, the esclamation point is used when declaring variables used all over the application so that we can use directly the variable skipping the necessary unwrapping of the optional
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var brain = CalculatorBrain()
    var userIsInTheMiddleOfTypingANumber = false    // all properties have to be initialized when the object is initialized
    
    var displayValue: Double? {
        get {
            if let val = NSNumberFormatter().numberFromString(display.text!) {
                return val.doubleValue
            }
            return nil
        }
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
        }
    }
    
    @IBAction func clear() {
        brain.clearStack()
        brain.variableValues.removeValueForKey("M")
        displayValue = 0
        desc.text = " "
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTypingANumber {
            // backspace
            if let val = display.text {
                if count(val) > 0 {
                    display.text = dropLast(val)
                }
            }
        } else {
            // undo last operation
        }
    }
    
    @IBAction func setVariable() {
        userIsInTheMiddleOfTypingANumber = false
        if let variableValue = displayValue {
            brain.variableValues["M"] = variableValue
            displayValue = brain.evaluate()
        }
    }
    
    @IBAction func getVariable() {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayValue = brain.pushOperand("M")
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!    // crashes if sender.currentTitle is nil
        if (userIsInTheMiddleOfTypingANumber) {
            if (digit != ".") || (display.text?.rangeOfString(".") == nil) {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
            desc.text = brain.description
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
}

