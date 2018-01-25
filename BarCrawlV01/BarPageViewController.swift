//
//  ViewController.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 11/27/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase



class BarPageViewController: UIViewController  {
    
    
    @IBOutlet weak var BarLabel: UITextField!
    
    public var barName = String()
    
    var thisPageData = barPageData()
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
       
        
        

        
        //BarLabel.text = barName
        
        let logo = UIImage(named: "TextLogoNoBackSmall.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit

        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        
        //Set the firebase ref
        ref = Database.database().reference().child("barPageDatas")
        
        //Retrieve the posts and listen for changes
        databaseHandle = ref.child(barName).observe(.childAdded) { (snapshot) in
        //Code to execute when a child is added
            
            //Convert the info of the data into a string variable
            if let getData = snapshot.value as? [String:Any] {
                
                let thisPageData = barPageData(getData : getData)
                self.BarLabel.text = thisPageData.barName
                
                
            }
        }
        
    }
    
    
    
  
    
    
    
    
    
    
    
    
    
}


