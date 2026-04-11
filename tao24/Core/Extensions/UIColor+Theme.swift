//
//  UIColor+Theme.swift
//  tao24
//
//  Created by Aditya Karki on 4/10/26.
//

import UIKit

extension UIColor {
    
    // MARK: - Canvas & Surfaces

    /*
     The primary background canvas:
     Light Mode -> Soft Stone (#F5F5F7) - Apple's signature background
     Dark Mode -> Rich Charcoal (#121212)
     */
    static let baseBackground = UIColor {trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0) :
            UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
    }

    /*
     The surface for cards and cells:
     Light Mode: Pure White (#FFFFFF)
     Dark Mode: Elevated Grey (#1C1C1E)
     */
    static let surface = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) :
            .white
    }

    // MARK: - Text Hierarchy
    
    /*
     High-contrast text for titlesL
     Light Mode: Deep Charcoal (#121212)
     Dark Mode: Off-White (#FAFAFA)
     */
    static let primaryText = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0) :
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)
    }
    
    /*
     Muted text for metadata:
     Light Mode: Darker Slate (#4A4A4D) - improved legibility
     Dark Mode: System Silver (#8E8E93)
     */
    static let secondaryText = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1.0) :
            UIColor(red: 0.29, green: 0.29, blue: 0.30, alpha: 1.0)
    }
    
    // MARK: - Branding & Utility
    
    /*
     The "Apple Identity" accent:
     Light Mode: Pure Black (#000000)
     Dark Mode: Pure White (#FFFFFF)
     */
    
    static let accent = UIColor { trait in
        return trait.userInterfaceStyle == .dark ? .white : .black
    }
    
    /*
     Subtle lines for separation:
     Light Mode: Medium Silver (#C7C7CC) - slightly darker for visibility
     Dark Mode: Deep Iron (#38383A)
     */
    static let separator = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1.0) :
            UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
}
