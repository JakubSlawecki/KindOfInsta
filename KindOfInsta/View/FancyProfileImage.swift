//
//  FancyProfileImage.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 21.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyProfileImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }
}
