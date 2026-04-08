//
//  UIView+AutoLayout.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

extension UIView {
    func pinToEdges(of container: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor),
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
