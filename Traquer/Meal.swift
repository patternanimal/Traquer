//
//  Meal.swift
//  Traquer
//
//  Created by Ryan Olson on 7/6/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit

class Meal {
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initializers
    init?(name: String, photo: UIImage?, rating: Int) {
        // Return if invalid values
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }

}

