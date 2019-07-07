//
//  MealTableViewCell.swift
//  Traquer
//
//  Created by Ryan Olson on 7/6/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var volumeStackView: UIStackView!
    var volumeDict: [String: String] = [:]
    
    func createLabelsAs(dict: [String: String]) {
        var yOffset = 0
        for (weight, sets) in dict {
            let label: UILabel = UILabel()
            
            if volumeDict.isEmpty {
                label.frame = CGRect(x: 0, y: 0
                    , width: 200, height: 30
                )
            } else {
                label.frame = CGRect(x: 0, y: yOffset , width: 200, height: 30)
                
            }

            label.textAlignment = NSTextAlignment.left
            let labelText: String = "Weight/Sets" + ": " + weight + "/" + sets
            label.text = labelText
            label.font = label.font.withSize(12)
            self.volumeStackView.addSubview(label)
            
            volumeDict[weight] = sets
            yOffset = Int(label.frame.origin.y + label.frame.height + 2)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
