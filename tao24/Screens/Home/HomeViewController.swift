//
//  HomeViewController.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI Components
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(helloLabel)
        
        // The simple way
        emptyStateView.pinToEdges(of: view)
        
        NSLayoutConstraint.activate([
            helloLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            helloLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
    }
}
