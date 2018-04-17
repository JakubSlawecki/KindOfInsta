//
//  FancyBtn.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 14.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {
                                            // this will provide round edges for buttons
    override func awakeFromNib() {
        
        super.awakeFromNib()
        layer.cornerRadius = 2.0
    }
}
