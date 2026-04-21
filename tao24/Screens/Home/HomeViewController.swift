//
//  HomeViewController.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Layout Constants

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 28
        static let cardSpacing: CGFloat = 12
        static let buttonHeight: CGFloat = 50
    }

    // MARK: - Data

    private var habits: [Habit] = []

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.cardSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No habits yet.\nTap the button below to add your first one."
        label.font = .secondary()
        label.textColor = .secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.applyStyle(.primary, title: "Add New Habit")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadList()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .baseBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Layout.verticalPadding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layout.horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layout.horizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Layout.verticalPadding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Layout.horizontalPadding * 2)
        ])

        // Header
        let headerLabel = UILabel()
        headerLabel.text = "Your Habits"
        headerLabel.font = .display()
        headerLabel.textColor = .primaryText
        contentStack.addArrangedSubview(headerLabel)
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: headerLabel)

        // Add button at the bottom (always visible)
        addButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight).isActive = true
        addButton.addTarget(self, action: #selector(addHabitTapped), for: .touchUpInside)
    }

    // MARK: - List Rendering

    private func reloadList() {
        // Remove everything after the header (index 0)
        while contentStack.arrangedSubviews.count > 1 {
            let view = contentStack.arrangedSubviews.last
            contentStack.removeArrangedSubview(view ?? UIView())
            view?.removeFromSuperview()
        }

        if habits.isEmpty {
            contentStack.addArrangedSubview(emptyLabel)
            contentStack.setCustomSpacing(Layout.sectionSpacing, after: emptyLabel)
        } else {
            for habit in habits {
                let card = createHabitCard(for: habit)
                contentStack.addArrangedSubview(card)
            }
            if let lastCard = contentStack.arrangedSubviews.last {
                contentStack.setCustomSpacing(Layout.sectionSpacing, after: lastCard)
            }
        }

        contentStack.addArrangedSubview(addButton)
    }

    // MARK: - Card Builder

    private func createHabitCard(for habit: Habit) -> UIView {
        let card = Card()

        let titleLabel = UILabel()
        titleLabel.text = habit.title
        titleLabel.font = .body()
        titleLabel.textColor = .primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let scheduleLabel = UILabel()
        scheduleLabel.text = habit.scheduledType.rawValue.capitalized
        scheduleLabel.font = .compact()
        scheduleLabel.textColor = .secondaryText
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(titleLabel)
        card.addSubview(scheduleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            scheduleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            scheduleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scheduleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        return card
    }

    // MARK: - Actions

    @objc private func addHabitTapped() {
        let addHabitVC = AddHabitViewController()
        addHabitVC.delegate = self
        let nav = UINavigationController(rootViewController: addHabitVC)
        present(nav, animated: true)
    }
}

// MARK: - AddHabitDelegate

extension HomeViewController: AddHabitDelegate {
    func addHabitViewController(_ controller: AddHabitViewController, didAdd habit: Habit) {
        controller.dismiss(animated: true)
        habits.append(habit)
        reloadList()
    }

    func addHabitViewControllerDidCancel(_ controller: AddHabitViewController) {
        controller.dismiss(animated: true)
    }
}
