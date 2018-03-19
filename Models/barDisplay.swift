//
//  barDisplay.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 11/27/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit


class barDisplay: NSObject {
    var barName : String?
    var barPictureUrl : String?
    //var barPictureUrlWED : String?
    //var barPictureUrlTHUR : String?
    
    init(getData : [String: Any]) {
        self.barName = getData["barName"] as? String
        self.barPictureUrl = getData["barPictureUrl"] as? String
        
        
        /*self.barPictureUrlWED = getData["barPictureUrlWED"] as? String
        self.barPictureUrlTHUR = getData["barPictureUrlTHUR"] as? String
        */

    }
    
    
    override init() {
        self.barName = ""
        self.barPictureUrl = ""
        //self.barPictureUrlWED = ""
        //self.barPictureUrlTHUR = ""
    }
    
    
    
    
}

