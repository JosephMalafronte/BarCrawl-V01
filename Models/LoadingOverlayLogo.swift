//
//  LoadingOverlayLogo.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 12/26/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit

public class LoadingOverlayLogo {
    
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingOverlayLogo {
        struct Static {
            static let instance: LoadingOverlayLogo = LoadingOverlayLogo()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        overlayView.backgroundColor = .black
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .gray
        overlayView.addSubview(activityIndicator)
    }
    
    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
