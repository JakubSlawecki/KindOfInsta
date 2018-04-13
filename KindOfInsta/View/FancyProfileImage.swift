//
//  FancyProfileImage.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 21.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyProfileImage: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
