//
//  PublicCellCollectionViewCell.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 31/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class PublicCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    func displayContent(number: String, title: Int){
        numberLabel.text = number;
        titleLabel.text = String(title);
    }
}
