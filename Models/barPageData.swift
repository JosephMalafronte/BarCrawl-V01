//
//  barDisplay.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 11/27/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit


class barPageData: NSObject {
    var barName : String?
    var barPictureUrl : String?
    
    
    init(getData : [String: Any]) {
        self.barName = getData["barName"] as? String
        //self.barPictureUrl = getData["barPictureUrl"] as? String
    }
    
    
    override init() {
        self.barName = ""
        self.barPictureUrl = ""
    }
}


