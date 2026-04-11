//
//  UIView+AutoLayout.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

extension UIView {
    
    // Simplifies the process of making a view fill its parent container.
    func pinToEdges(padding: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding)
        ])
    }
    
    // Perfectly aligns the center point of this view with its parent.
    func centerInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    // Provides a quick way to set fixed width and height values.
    func setDimensions(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }

    /* Adds a structural divider line.
     - Parameters:
     - position: The edge (.bottom or .right) where the separator is anchored.
     - color: The tint of the divider.
     - thickness: The gauge of the line in points.
     - inset: The margin applied to the start and end of the separator.
     */
    func addSeparator(at position: SeparatorPosition, color: UIColor = .separator, thickness: CGFloat = 0.5, inset: CGFloat = 0) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        
        if position == .bottom {
            // Horizontal Line
            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: thickness),
                separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            // Vertical Line (Right)
            NSLayoutConstraint.activate([
                separator.widthAnchor.constraint(equalToConstant: thickness),
                separator.topAnchor.constraint(equalTo: topAnchor, constant: inset),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}


enum SeparatorPosition {
    case bottom, right
}
