//
//  ListTableViewCell.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

 
    @IBOutlet weak var nameField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
