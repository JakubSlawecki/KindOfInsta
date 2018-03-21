//
//  FancyProfileImage.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 21.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyProfileImage: UIImageView {

    func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
