//
//  CountriesTableViewCell.swift
//  MatrixCountriesProjectCohenChayaMushka
//
//  Created by hyperactive on 07/06/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet var countryNameLabel: UILabel!
    
    @IBOutlet weak var countryArea: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countryNameLabel.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height / 3)
        countryNameLabel.adjustsFontSizeToFitWidth = true
        countryNameLabel.textAlignment = .center
        
        countryArea.frame = CGRect(x: 0, y: contentView.bounds.height / 3, width: contentView.bounds.width, height: contentView.bounds.height / 3)
        countryArea.adjustsFontSizeToFitWidth = true
        countryArea.textAlignment = .center

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }

}

