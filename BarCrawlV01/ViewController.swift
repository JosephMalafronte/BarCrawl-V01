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
    @IBOutlet weak var NavBarTop: NSLayoutConstraint!
    @IBOutlet weak var FarLeftButton: UIBarButtonItem!
    @IBOutlet weak var CloseRightButton: UIBarButtonItem!
    
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    var barDisplays = [barDisplay]()
    var allBarDisplaysCached = false
    
    var beenLoaded = false
    var barNames = [String]()
    var destinationBar = String()
    let dayNum =  Calendar.current.component(.weekday, from: Date())

    
    //Utitlity Function for Resizing images
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //Load First
    override func viewWillAppear(_ animated: Bool) {
        //Set White Status Bar
        
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Hide Nav Controller
        if(beenLoaded == false) {self.navigationController?.setNavigationBarHidden(true, animated: animated)}
        else {
            NavBarTop.constant = 0
            self.view.layoutIfNeeded()
        }
        
        //Load button images
        var FarLeftButtonImage = UIImage(named: "FarLeftButtonSmall.png")
        FarLeftButtonImage = imageWithImage(image: FarLeftButtonImage!, scaledToSize: CGSize(width: 30, height: 20))
        FarLeftButton.image = FarLeftButtonImage
        
        var CloseRightButtonImage = UIImage(named: "ProfileIcon.png")
        CloseRightButtonImage = imageWithImage(image: CloseRightButtonImage!, scaledToSize: CGSize(width: 35, height: 35))
        CloseRightButton.image = CloseRightButtonImage
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet var HomeView: UIView!
    
    let overlayLogo = LoadingOverlayLogo()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate=self
        tableView.dataSource=self
        
        let logo = UIImage(named: "TextLogoNoBackSmall.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        //Loading Overlay
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
                    print("All Images All ready loaded")
                    
                }
                overlayLogo.hideOverlayView()
                self.viewWillDisappear(false)
                self.beenLoaded = true
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
        
        
        
        //Call getUrlString function
        let urlString = getUrlStringByDay(barD: thisBarDisplay, dayNum: self.dayNum)
        
        //Paste
        cell.barImage.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            cell.barImage.image = cachedImage
            incDownloadImageCount(count: numberTotalBarDisplays)
            barNames.append(cell.barName.text!)
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
                        self.barNames.append(cell.barName.text!)
                        
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
         
        print(barDisplays[indexPath.row].barName!)
        destinationBar = barDisplays[indexPath.row].barName!
        performSegue(withIdentifier: "SegueToBarPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let BarPageController = segue.destination as! BarPageViewController
        BarPageController.barName = destinationBar
    }
    
    
    
    
    func getUrlStringByDay(barD: barDisplay, dayNum: Int) -> String{
        switch dayNum{
            case 4 :
                return barD.barPictureUrlWED!
            case 5 :
                return barD.barPictureUrlTHUR!
            default :
                return barD.barPictureUrl!
        }
        
        
        
    }
    
    
    
    
}

