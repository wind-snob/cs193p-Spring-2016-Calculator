//
//  CalculatorBrain.swift
//  cs193p Spring 2016 Calculator
//
//  Created by Home on 5/9/16.
//  Copyright © 2016 student.com. All rights reserved.
//

import Foundation

class CalculatorBrain {
  
  private enum Operation {
    
    case Constant(Double)
    case UnaryOperation(Double -> Double)
    case BinaryOperation((Double,Double) -> Double)
    case Equals
    case Clear
  }
  
  private var operations = [String : Operation]()
  
  init() {
    operations.updateValue(.Constant(M_PI), forKey: "π")
    operations.updateValue(.BinaryOperation(+), forKey: "+")
    operations.updateValue(.BinaryOperation(-), forKey: "-")
    operations.updateValue(.BinaryOperation(*), forKey: "x")
    operations.updateValue(.BinaryOperation(/), forKey: "÷")
    operations.updateValue(.UnaryOperation({-$0}), forKey: "±")
    operations.updateValue(.UnaryOperation(sqrt), forKey: "√")
    operations.updateValue(.UnaryOperation(sin), forKey: "sin")
    operations.updateValue(.Equals, forKey: "=")
    operations.updateValue(.Clear, forKey: "C")
  }
  
  private var accumulator = 0.0
  private var lastOpp: Operation?
  private var pendingOpp: Bool?
  
  var description = "0"                                           // public API
  var isPartialResult: Bool {                                     // public API
    get {
      return pendingOpp != nil
    }
  }
  
  func setOperand(operand: Double) {                              // public API
    
    accumulator = operand
  }
  
  func performOperation(symbol: String) {                         // public API
    
    if let operation = operations[symbol] {
      
      switch operation {
        
      case .Constant(let value):
        accumulator = value
        
      default:
        break
      }
    }
  }
  
  var result: Double {                                            // public API
    get {
      return accumulator
    }
  }
  
  private func formatNumber(value: Double) -> String {
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    
    if value == Double(Int(value)) {
      formatter.maximumFractionDigits = 0
    } else {
      formatter.maximumFractionDigits = 3
    }
    
    if let result = formatter.stringFromNumber(value){
      return result
    } else {
      return "ERROR"
    }
  }
}