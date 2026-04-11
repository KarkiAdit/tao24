//
//  UIButton+Theme.swift
//  tao24
//
//  Created by Aditya Karki on 4/10/26.
//

import UIKit

/*
 Defines the visual hierarchy for buttons in the application.
 */
enum ButtonStyle {
    case primary
    case secondary
    case tertiary
}

extension UIButton {

    // Applies a design system style to the button using tao24 theme colors.
    func applyStyle(_ style: ButtonStyle, title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.cornerRadius = 12
        
        switch style {
        case .primary:
            backgroundColor = .accent
            setTitleColor(.baseBackground, for: .normal)
            layer.borderWidth = 0
            
        case .secondary:
            backgroundColor = .clear
            layer.borderWidth = 1.5
            layer.borderColor = UIColor.accent.cgColor
            setTitleColor(.accent, for: .normal)
            
        case .tertiary:
            backgroundColor = .clear
            layer.borderWidth = 0
            setTitleColor(.secondaryText, for: .normal)
        }
    }

    // Toggles the button's interactivity and visual state.
    func setEnabledState(_ enabled: Bool) {
        self.isEnabled = enabled
        self.alpha = enabled ? 1.0 : 0.4
    }

    // Manages visual feedback for asynchronous operations.
    func setLoading(_ isLoading: Bool, originalTitle: String = "") {
        isEnabled = !isLoading
        setTitle(isLoading ? "Loading..." : originalTitle, for: .normal)
    }
}
