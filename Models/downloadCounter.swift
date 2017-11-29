//
//  downloadCounter.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 11/28/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit


class downloadCounter: NSObject {
    var count : Int?
  
    override init() {
        self.count = 0
        //Test
    }
    
    @objc func runTimedCode () {
        print("test")
    }
}
