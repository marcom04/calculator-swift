//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Marco Marchini on 11/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable      // this enum implements the protocol Printable
    {
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    var variableValues = [String: Double]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π", M_PI))
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func description(ops: [Op]) -> (result: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (NSNumberFormatter().stringFromNumber(operand)!, remainingOps)
            case .Constant(let symbol, _):
                return (symbol, remainingOps)
            case .Variable(let symbol):
                return (symbol, remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandDescription = description(remainingOps)
                let dsc = symbol + "(" + operandDescription.result + ")"
                return (dsc, operandDescription.remainingOps)
            case .BinaryOperation(let symbol, _):
                let op1Description = description(remainingOps)
                let op2Description = description(op1Description.remainingOps)
                let dsc = "(" + op2Description.result + symbol + op1Description.result + ")"
                return (dsc, op2Description.remainingOps)
            }
        }
        return ("?", ops)
    }
    
    var description: String {
        get {
            var descriptions = [String]()
            var operations = opStack
            while !operations.isEmpty {
                let (result, remainder) = description(operations)
                descriptions.insert(result, atIndex: 0)
//                println("description = \(result) with \(remainder) left over")
                operations = remainder
            }
            return ",".join(descriptions)+"="
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Constant(_, let operand):
                return (operand, remainingOps)
            case .Variable(let symbol):
                if let variable = variableValues[symbol] {
                    return (variableValues[symbol], remainingOps)
                }
                return (nil, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
//        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func clearStack() {
        opStack.removeAll()
    }
    
    
}