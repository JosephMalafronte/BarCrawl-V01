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

let numDownloadCache = NSCache<AnyObject, AnyObject>()


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    var barDisplays = [barDisplay]()
    var allBarDisplaysCached = false
    
    
    //Set white status bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet var HomeView: UIView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate=self
        tableView.dataSource=self
        
        //Loading Overlay
        let overlayLogo = LoadingOverlayLogo()
        overlayLogo.showOverlay(view: HomeView)
        
        //Set the firebase ref
        ref = Database.database().reference()
        
        //Retrieve the posts and listen for changes
        databaseHandle = ref.child("barDisplays").observe(.childAdded) { (snapshot) in
            //Code to execute when a child is added
            
            //Convert the info of the data into a string variable
            if let getData = snapshot.value as? [String:Any] {
                
                let currentBarDisplay = barDisplay(getData : getData)
                
                self.barDisplays.append(currentBarDisplay)
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barDisplays.count
    }
    
    
    
    
    func incDownloadImageCount (count: Int) {
        if let cachedNumObj = numDownloadCache.object(forKey: "num" as AnyObject) as? downloadCounter {
            cachedNumObj.count! += 1
            if(cachedNumObj.count == count){
                if(self.allBarDisplaysCached == false){
                    print("Done Loading All Images!")
                    self.allBarDisplaysCached = true
                }
                else {
                    print("All Images Allready loaded")
                }
                
            }
            numDownloadCache.setObject(cachedNumObj, forKey: "num" as AnyObject)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath) as! ViewControllerTableViewCell
        
        let thisBarDisplay = self.barDisplays[indexPath.row]
        
        cell.barImage.image = UIImage(named: "burrito")
        let numberTotalBarDisplays = barDisplays.count
        
        let countDl = downloadCounter()
        
        numDownloadCache.setObject(countDl, forKey: "num" as AnyObject)
        
        
        //cell.barImage.loadImageUsingCacheWithUrlString(thisBarDisplay.barPictureUrl!)
        
        let urlString = thisBarDisplay.barPictureUrl!
        
        //Paste
        cell.barImage.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            cell.barImage.image = cachedImage
            incDownloadImageCount(count: numberTotalBarDisplays)
        }
        else {
            //otherwise fire off a new download
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        //Cache Image
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        
                        cell.barImage.image = downloadedImage
                        
                        self.incDownloadImageCount(count: numberTotalBarDisplays)

                    }
                })
                
            }).resume()
        }
        
        
        
        
    
        
        
        
        
        if let barNameIns = thisBarDisplay.barName{
            cell.barName.text = barNameIns
        }
        
        
        return (cell)
    }
    
    
    
    
    
}

