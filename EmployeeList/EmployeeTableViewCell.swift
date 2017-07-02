//
//  EmployeeTableViewCell.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 02/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

protocol TableViewCellFavouriteButtonClicked {
    func onclick(tag: Int, favourite: Bool)
}

class EmployeeTableViewCell: UITableViewCell {
    
    var favouriteClicked: TableViewCellFavouriteButtonClicked?
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func favouriteClicked(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "filledStar") {
            favouriteClicked?.onclick(tag: sender.tag, favourite: true)
        } else {
            favouriteClicked?.onclick(tag: sender.tag, favourite: false)
        }
        
    }
}
