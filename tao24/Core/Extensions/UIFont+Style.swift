//
//  UIFont+Style.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

extension UIFont {
    // Use for high-impact titles and primary branding elements that require maximum visual weight.
    static func display(size: CGFloat = 34) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    // Designed for section headers and prominent labels that organize content within a view.
    static func header(size: CGFloat = 20) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
    
    // The primary typeface for long-form text and habit descriptions to ensure optimal readability.
    static func body(size: CGFloat = 17) -> UIFont {
        return UIFont(name: "OpenSans-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    // A space-efficient variant ideal for metadata, timestamps, and dense data points in tight layouts.
    static func compact(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "OpenSans_Condensed-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    // Appropriate for low-emphasis text such as hints, placeholders, or secondary supporting information.
    static func secondary(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
}
