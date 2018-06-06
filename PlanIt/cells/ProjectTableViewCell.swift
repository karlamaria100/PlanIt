//
//  ProjectTableViewCell.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 19/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adminButton: UIButton!
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var finishDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
