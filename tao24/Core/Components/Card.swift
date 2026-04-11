//
//  Card.swift
//  tao24
//
//  Created by Aditya Karki on 4/10/26.
//


import UIKit

/*
 A standardized surface component for tao24, automatically adapting to light and dark mode surfaces.
 */
class Card: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        backgroundColor = .surface
        layer.cornerRadius = 16
        
        // Use your separator color for a subtle, theme-aware border
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.separator.cgColor
        
        // Standard elevation
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
    }
}
