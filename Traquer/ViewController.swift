//
//  ViewController.swift
//  Traquer
//
//  Created by Ryan Olson on 7/5/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }
}


