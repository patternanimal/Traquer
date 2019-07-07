//
//  MealViewController.swift
//  Traquer
//
//  Created by Ryan Olson on 7/5/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var sessionTemplatePicker: UIPickerView!
    @IBOutlet weak var templateSelectButton: UIButton!
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    
    var transitionTo: Int = 0
    var transactionId: Int = 0
    var pickerList: [String] = [String]()
    var labelList: [UILabel] = [UILabel]()
    
    // Track data about the current picker state
    // TODO do I need both of these, clean it up!
    var currentPickerIndex: Int = 0
    var currentPickerString: String?
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picker Data
        // Connect data:
        self.sessionTemplatePicker.delegate = self
        self.sessionTemplatePicker.dataSource = self
        pickerList = ["", "Bench", "Squat", "Deadlift"]
        
        
        // Disable views initially, to be later turned on through flow
        self.templateSelectButton.isHidden = true
        self.sessionTemplatePicker.isHidden = true
        self.sessionTemplatePicker.isHidden = true
        self.photoImageView.isHidden = true
        self.ratingControl.isHidden = true
        
        // Style buttons with rounded edges
        styleRoundedButton(button: self.templateSelectButton)
        
        // Handle user input through delegate callback
        //nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            //nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
            navigationItem.title = meal.date
        } else {
            let dateCal = Date()
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMMMdYYYY")
            let result = formatter.string(from: dateCal)
            navigationItem.title = result
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        transitionToNext()
    }
    
    // Ryan ADDS
    private func styleRoundedButton(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: Picker Template Session List
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set picker index anytime a new selection is made
        currentPickerIndex = row
        
        // Set picker string already converted when a new selection is made
        currentPickerString = pickerList[row] as String
    }
    
    private func createLabelAs(type: String, value: String) {
        
        let label: UILabel = UILabel()
        
        if labelList.isEmpty {
            label.frame = CGRect(x: 0, y: 0
                , width: 200, height: 30
            )
        } else {
            label.frame = CGRect(x: 0, y: labelList[labelList.endIndex - 1].frame.origin.y + 38 , width: 200, height: 30)
        
        }
        //label.backgroundColor = UIColor.black
        //label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        let labelText: String = type + ": " + value
        label.text = labelText
        self.labelsStackView.addSubview(label)
        self.labelList.append(label)
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        //textField.resignFirstResponder()
        
        // Do we want to always process the text field?
        // If so, return true, otherwise handle cases
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Chance to handle/process the input just after
        // resigning first repsonder from textFieldShouldReturn
        //updateSaveButtonState()
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Animate out and nothing to do
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    private func processTransaction() {
        // Handle any transactions that occur
        switch transactionId {
        case 0:
            transactionId+=1
        case 1:
            // Turn off functionality of Lift picker
            self.sessionTemplatePicker.resignFirstResponder()
            self.sessionTemplatePicker.isHidden = true
            
            // Create a new label entry from picker selection
            createLabelAs(type: "Lift", value: currentPickerString ?? "error")
            transactionId+=1
        case 2:
            ratingControl.isHidden = true
            createLabelAs(type: "Rating", value: String(ratingControl.rating))
            transactionId+=1
        case 3:
            transactionId+=1
        default:
            fatalError("transaction ID exceeded available transactions")
        }
        
    }
    
    //MARK: Inner Navigation
    private func transitionToNext() {
        // TODO write a way to easily transition between views
        
        switch transitionTo {
            case 0:
                self.templateSelectButton.isHidden = false
                templateNameLabel.text = "Create New Workout"
                transitionTo += 1
            case 1:
                self.sessionTemplatePicker.isHidden = false
                templateNameLabel.text = "Select Lift"
                transitionTo += 1
            case 2:
                ratingControl.isHidden = false
                templateNameLabel.text = "Rate Session"
                transitionTo += 1
            case 3:
                templateSelectButton.setTitle("Done", for: .normal)
                transitionTo += 1
            default:
                fatalError("transition to exceeded available transitions")
        }
        
        
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
       
        let name = "Placeholder Name"
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let date = navigationItem.title ?? ""
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating, date: date)
    }
    
    //MARK: Actions    
    @IBAction func templateAction(_ sender: UIButton) {
        processTransaction()
        transitionToNext()
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // If user picks the image while the keyboard is up
        //nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        //let text = nameTextField.text ?? ""
        //saveButton.isEnabled = !text.isEmpty
    }
}


