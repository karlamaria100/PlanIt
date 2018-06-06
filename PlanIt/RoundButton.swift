//
//  RoundButton.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 26/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton{
    
    
    override init(frame: CGRect) {
        self.cornerRadius = 0;
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cornerRadius = 0;
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
}
