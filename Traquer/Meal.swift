//
//  Meal.swift
//  Traquer
//
//  Created by Ryan Olson on 7/6/19.
//  Copyright © 2019 Free Range. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    //MARK: Properties
    struct PropertyKey {
        // DEPRE name is unused
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let date = "date"
        static let lift = "lift"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var date: String
    var lift: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    //MARK: Initializers
    init?(name: String, photo: UIImage?, rating: Int, date: String, lift: String) {
        // Return if invalid values
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !date.isEmpty else {
            return nil
        }
        
        guard !lift.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.date = date
        self.lift = lift
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        guard let lift = aDecoder.decodeObject(forKey: PropertyKey.lift) as? String else {
            os_log("Unable to decode the lift of the Workout object", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else {
            os_log("Unable to decode the date for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, date: date, lift: lift)
    }
    
    
}

