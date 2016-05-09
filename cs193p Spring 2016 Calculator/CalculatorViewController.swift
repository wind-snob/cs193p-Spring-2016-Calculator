//
//  CalculatorViewController.swift
//  cs193p Spring 2016 Calculator
//
//  Created by Home on 5/8/16.
//  Copyright © 2016 student.com. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  let brain = CalculatorBrain()
  
  var userIsInTheMiddleOfTyping = false
  
  var displayValue: Double {                                  // computed property converts String to Double
    get {
      return Double(display.text!)!
    }
    set {
      let formatter = NSNumberFormatter()
      formatter.numberStyle = .DecimalStyle
      formatter.maximumFractionDigits = 6
      display.text = formatter.stringFromNumber(newValue)
    }
  }
  
  @IBOutlet private weak var display: UILabel!                // calculator main display
  
  @IBOutlet weak var descDisplay: UILabel!                    // description display
  
  
  @IBAction private func touchDigit(sender: UIButton) {       // enter digit from keypad
    
    let digit = sender.currentTitle!
    let textCurrentlyInDisplay = display.text!
    
    if userIsInTheMiddleOfTyping {
      
      if digit != "." || textCurrentlyInDisplay.rangeOfString(".") == nil {  // only allow to enter one period
        display.text = textCurrentlyInDisplay + digit
      }
      
    } else {
      display.text = digit
      userIsInTheMiddleOfTyping = true
    }
  }
  
  @IBAction private func performOperation(sender: UIButton) { // enter math symbol from keypad
    
    let mathSymbol = sender.currentTitle!
    
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
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

