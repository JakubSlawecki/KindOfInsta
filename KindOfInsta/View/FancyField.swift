//
//  FancyField.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 14.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class FancyField: UITextField {
                                        // this will ensure space between the text and the edge of the text field
    override func textRect(forBounds bounds: CGRect) -> CGRect {
       
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
