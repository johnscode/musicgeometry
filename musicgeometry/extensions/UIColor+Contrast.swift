//
//  UIColor+Contrast.swift
//  musicgeometry
//
//  Created by John Fowler on 1/3/25.
// Copyright (C) John J. Fowler 2024, 2025
//

import UIKit

extension UIColor {
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Using relative luminance formula
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }
    
    var contrastingColor: UIColor {
        return luminance > 0.5 ? .black : .white
    }
}
