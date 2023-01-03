//
//  UIColor+Extension.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 2/1/23.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        UIColor(
            displayP3Red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1),
            alpha: 1
        )
    }
    
}
