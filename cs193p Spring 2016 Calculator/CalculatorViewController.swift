//
//  CalculatorViewController.swift
//  cs193p Spring 2016 Calculator
//
//  Created by Home on 5/8/16.
//  Copyright © 2016 student.com. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  private let brain = CalculatorBrain()
  
  private var userIsInTheMiddleOfTyping = false
  
  private var displayValue: Double? {                                  // computed property converts String to Double
    get {
      return Double(display.text!)
    }
    set {
      let formatter = NSNumberFormatter()
      formatter.numberStyle = .DecimalStyle
      formatter.maximumFractionDigits = 6
      
      if let newValue = newValue {
      display.text = formatter.stringFromNumber(newValue)
      } else {
        display.text = ""
      }
    }
  }
  
  @IBOutlet private weak var display: UILabel!                // calculator main display
  
  @IBOutlet private weak var descDisplay: UILabel!                    // description display
  
  
  @IBAction private func touchDigit(sender: UIButton) {       // enter digit from keypad
    
    let digit = sender.currentTitle!
    let textCurrentlyInDisplay = display.text!
    
    if userIsInTheMiddleOfTyping {
      if digit == "⬅︎" {
        if textCurrentlyInDisplay.characters.count == 1 {
          display.text = "0"
          userIsInTheMiddleOfTyping = false
        } else {
          display.text = textCurrentlyInDisplay.substringToIndex(textCurrentlyInDisplay.endIndex.predecessor())
        }
      } else if digit != "." || textCurrentlyInDisplay.rangeOfString(".") == nil {  // only allow to enter one period
        display.text = textCurrentlyInDisplay + digit
      }
    } else if digit != "⬅︎" {
      display.text = digit
      userIsInTheMiddleOfTyping = true
    }
  }
  
  @IBAction private func performOperation(sender: UIButton) { // enter math symbol from keypad
    
    let mathSymbol = sender.currentTitle!
    
    if userIsInTheMiddleOfTyping {
      if let displayValue = displayValue {
        brain.setOperand(displayValue)
      } else {
        brain.setOperand(0.0)
      }
      userIsInTheMiddleOfTyping = false
    }
    
    brain.performOperation(mathSymbol)
    displayValue = brain.result
    
    if brain.description == "0" {
      descDisplay.text = " "
    } else if brain.isPartialResult {
      descDisplay.text = brain.description + "..."
    } else {
      descDisplay.text = brain.description + "="
    }
  }
}

