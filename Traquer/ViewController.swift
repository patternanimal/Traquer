//
//  ViewController.swift
//  Traquer
//
//  Created by Ryan Olson on 7/5/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle user input through delegate callback
        nameTextField.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        // Do we want to always process the text field?
        // If so, return true, otherwise handle cases
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Chance to handle/process the input just after
        // resigning first repsonder from textFieldShouldReturn
        mealNameLabel.text = textField.text
    }
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }
}


