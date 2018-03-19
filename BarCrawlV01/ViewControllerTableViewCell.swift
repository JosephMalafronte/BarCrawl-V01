//
//  ViewControllerTableViewCell.swift
//  BarCrawlV01
//
//  Created by Joseph Malafronte on 11/27/17.
//  Copyright © 2017 Joseph Malafronte. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var barImage: UIImageView!
    @IBOutlet weak var barName: UILabel!
    @IBOutlet weak var dayText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
