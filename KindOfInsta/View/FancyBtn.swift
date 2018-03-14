//
//  FancyBtn.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 14.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {

                                            //this code will round the corners of the button if I want to
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 2.0
    }

}
