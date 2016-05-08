//
//  CalculatorViewController.swift
//  cs193p Spring 2016 Calculator
//
//  Created by Home on 5/8/16.
//  Copyright © 2016 student.com. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

  var userIsInTheMiddleOfTyping = false

  @IBOutlet private weak var display: UILabel!
  
  @IBAction private func touchDigit(sender: UIButton) {
    
    let digit = sender.currentTitle!
    let textCurrentlyInDisplay = display.text!
    
    if userIsInTheMiddleOfTyping {
      
      display.text = textCurrentlyInDisplay + digit
    } else {
      
      display.text = digit
      userIsInTheMiddleOfTyping = true
    }
  }
  
  @IBAction private func performOperation(sender: UIButton) {
    
  }
  
}

