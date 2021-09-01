//
//  CountrySelectedTableViewCell.swift
//  MatrixCountriesProjectCohenChayaMushka
//
//  Created by hyperactive on 20/06/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class CountrySelectedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        countryNameLabel.frame = CGRect(x: 10, y: 10, width: self.contentView.bounds.width - 20, height: self.contentView.bounds.height)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
