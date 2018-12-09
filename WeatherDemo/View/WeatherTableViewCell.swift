//
//  WeatherTableViewCell.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/8.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    // MARK: Property value

    @IBOutlet weak var dateTimeTitle: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var weatherStatusTitle: UILabel!
    
    @IBOutlet weak var weatherTempTitle: UILabel!
    
    // MARK: Lifecycle function
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.orange
        self.selectedBackgroundView = colorView
        
        self.backgroundColor = UIColor.clear
        
        self.dateTimeTitle.textColor = UIColor.white
        
        self.weatherStatusTitle.textColor = UIColor.white
        
        self.weatherTempTitle.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }

}
