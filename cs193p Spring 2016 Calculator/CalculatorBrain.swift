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
    case NullaryOperation( () -> Double)
    case UnaryOperation( (Double) -> Double)
    case BinaryOperation((Double,Double) -> Double)
    case Equals
    case Clear
  }
  
  private var pendingOpp: PendingBinaryOperationInfo?
  
  private struct PendingBinaryOperationInfo {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
    var symbol: String
  }
  
  private var operations = [String : Operation]()
  
  init() {
    operations.updateValue(.Constant(M_PI), forKey: "π")
    operations.updateValue(.Constant(M_E), forKey: "e")
    operations.updateValue(.BinaryOperation(+), forKey: "+")
    operations.updateValue(.BinaryOperation(-), forKey: "-")
    operations.updateValue(.BinaryOperation(*), forKey: "x")
    operations.updateValue(.BinaryOperation(/), forKey: "÷")
    operations.updateValue(.UnaryOperation({-$0}), forKey: "±")
    operations.updateValue(.UnaryOperation(sqrt), forKey: "√")
    operations.updateValue(.UnaryOperation(sin), forKey: "sin")
    operations.updateValue(.Equals, forKey: "=")
    operations.updateValue(.Clear, forKey: "C")
    operations.updateValue(.NullaryOperation(drand48), forKey: "rand")
  }
  
  typealias PropertyList = AnyObject
  
  private var internalProgram = [AnyObject]()
  
  var program: PropertyList {
    get {
      return internalProgram
    }
    set {
      clear()
      if let arrayOfOps = newValue as? [AnyObject] {
        for op in arrayOfOps {
          if let operand = op as? Double {
            setOperand(operand)
          } else if let operation = op as? String {
            performOperation(operation)
          }
        }
      }
    }
  }
  
  func clear() {
    accumulator = 0.0
    description = "0"
    oppDescription = "0"
    lastOpp = nil
    pendingOpp = nil
    internalProgram.removeAll()
  }
  
  private var accumulator = 0.0
  private var oppDescription = "0"
  private var lastOpp: Operation?
  
  var description = "0"
  var isPartialResult: Bool {
    get {
      return pendingOpp != nil
    }
  }
  
  func setOperand(operand: Double) {
    
    accumulator = operand
    internalProgram.append(operand)
  }
  
  func performOperation(symbol: String) {
    
    if let operation = operations[symbol] {
      
      internalProgram.append(symbol)
      
      switch operation {
        
      case .BinaryOperation(let opp):
        if pendingOpp != nil {
          
          switch lastOpp! {
            
          case .Constant( _ ):
            oppDescription = pendingOpp!.symbol
            
          case .UnaryOperation( _ ):
            oppDescription = pendingOpp!.symbol
            
          default:
            oppDescription = formatNumber(accumulator) + symbol
          }
          description += oppDescription
          accumulator = pendingOpp!.binaryFunction(pendingOpp!.firstOperand, accumulator)
          
        } else {
          if description == "0" {
            oppDescription = formatNumber(accumulator) + symbol
          } else {
            switch lastOpp! {
            case .Equals:
              oppDescription = description + symbol
            default:
              oppDescription = formatNumber(accumulator) + symbol
            }
          }
          description = oppDescription
        }
        pendingOpp = PendingBinaryOperationInfo(binaryFunction: opp, firstOperand: accumulator, symbol: symbol)
        
      case .UnaryOperation(let opp):
        if pendingOpp != nil {
          oppDescription = symbol + "(\(formatNumber(accumulator)))"
          description += oppDescription
        } else {
          if description == "0" {
            oppDescription = symbol + "(\(formatNumber(accumulator)))"
          } else {
            oppDescription = symbol + "(\(description))"
          }
          description = oppDescription
        }
        accumulator = opp(accumulator)
        
      case .NullaryOperation(let opp):
        accumulator = opp()
        
      case .Constant(let value):
        if pendingOpp == nil {
          description = ""
        }
        oppDescription = symbol
        description += oppDescription
        accumulator = value
        
      case .Equals:
        if pendingOpp != nil {
          
          switch lastOpp! {
            
          case .Constant( _ ):
            oppDescription = ""
            
          case .UnaryOperation( _ ):
            oppDescription = ""
            
          default:
            oppDescription = formatNumber(accumulator)
          }
          description += oppDescription
          accumulator = pendingOpp!.binaryFunction(pendingOpp!.firstOperand, accumulator)
          pendingOpp = nil
        }
        
      case .Clear:
        clear()
      }
      
      lastOpp = operation
    }
  }
  
  var result: Double {
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