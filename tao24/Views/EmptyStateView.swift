//
//  EmptyStateView.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

final class EmptyStateView: UIView {
    
    // MARK: - UI Components
    // TODO: Define a UIImageView for a calm illustration or icon
    // TODO: Define a UILabel for the 'Zen' message
    // TODO: Define a ZenButton to encourage the first action
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        // TODO: Set background color and add subviews
    }
    
    private func setupConstraints() {
        // TODO: Layout components using NSLayoutConstraint
    }
}
