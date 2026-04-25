//
//  AddHabitViewController.swift
//  tao24
//
//  Created by Aditya Karki on 4/21/26.
//

import UIKit

// MARK: - Delegate Protocol

protocol AddHabitDelegate: AnyObject {
    func addHabitViewController(_ controller: AddHabitViewController, didAdd habit: Habit)
    func addHabitViewControllerDidCancel(_ controller: AddHabitViewController)
}

// MARK: - AddHabitViewController

final class AddHabitViewController: UIViewController {

    // MARK: - Delegate

    weak var delegate: AddHabitDelegate?

    // MARK: - Layout Constants

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 28
        static let itemSpacing: CGFloat = 12
        static let fieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        static let dayButtonSize: CGFloat = 40
        static let chipHeight: CGFloat = 36
        static let chipSpacing: CGFloat = 8
    }

    // MARK: - Suggestion Data

    private let suggestions: [(title: String, icon: String)] = [
        ("Drink Water", "drop.fill"),
        ("Meditate", "brain.head.profile"),
        ("Read", "book.fill"),
        ("Exercise", "figure.run"),
        ("Journal", "pencil.line"),
        ("Sleep Early", "moon.fill"),
        ("Walk", "figure.walk"),
        ("Gratitude", "heart.fill")
    ]

    private let iconOptions: [String] = [
        "drop.fill", "brain.head.profile", "book.fill", "figure.run",
        "pencil.line", "moon.fill", "figure.walk", "heart.fill",
        "leaf.fill", "star.fill", "sun.max.fill", "bolt.fill",
        "flame.fill", "cup.and.saucer.fill", "music.note", "paintbrush.fill",
        "dumbbell.fill", "bed.double.fill"
    ]

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.itemSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleTextField: UITextField = makeStyledTextField(
        placeholder: "e.g. Meditate for 10 minutes"
    )

    private let suggestionScroll: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let suggestionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Layout.chipSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let iconPickerRow: Card = {
        let card = Card()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.isUserInteractionEnabled = true
        return card
    }()

    private let selectedIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .secondaryText
        iv.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        iv.image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        return iv
    }()

    private lazy var purposeField: UITextField = makeStyledTextField(
        placeholder: "e.g. I want to feel calmer and more focused"
    )

    private let scheduleSegment: UISegmentedControl = {
        let items = Habit.HabitScheduleType.allCases.map { $0.rawValue.capitalized }
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private let dayButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    private let reminderSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .accent
        return sw
    }()

    private let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .compact
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.isHidden = true
        return dp
    }()

    private let anchorHabitContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.itemSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    private lazy var anchorHabitField: UITextField = makeStyledTextField(
        placeholder: "e.g. After I pour my morning coffee"
    )

    private let commitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.applyStyle(.primary, title: "Start My Journey")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - State

    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    private var dayButtons: [UIButton] = []
    private var selectedDays: Set<Int> = []
    private var selectedIconName: String?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupActions()
        updateCommitButtonState()
    }

    // MARK: - Navigation

    private func setupNavigation() {
        title = "New Habit"
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
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

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Layout.horizontalPadding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layout.horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layout.horizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Layout.horizontalPadding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Layout.horizontalPadding * 2)
        ])

        buildForm()
    }

    private func buildForm() {
        buildHabitSection()
        buildWhySection()
        buildWhenSection()

        contentStack.addArrangedSubview(commitButton)
        commitButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight).isActive = true
    }

    // MARK: - Form Sections

    private func buildHabitSection() {
        contentStack.addArrangedSubview(makeSectionLabel("WHAT'S YOUR HABIT?"))

        // Suggestion chips above the text field
        buildSuggestionChips()
        suggestionScroll.addSubview(suggestionStack)
        contentStack.addArrangedSubview(suggestionScroll)

        NSLayoutConstraint.activate([
            suggestionStack.topAnchor.constraint(equalTo: suggestionScroll.topAnchor),
            suggestionStack.leadingAnchor.constraint(equalTo: suggestionScroll.leadingAnchor),
            suggestionStack.trailingAnchor.constraint(equalTo: suggestionScroll.trailingAnchor),
            suggestionStack.bottomAnchor.constraint(equalTo: suggestionScroll.bottomAnchor),
            suggestionStack.heightAnchor.constraint(equalTo: suggestionScroll.heightAnchor),
            suggestionScroll.heightAnchor.constraint(equalToConstant: Layout.chipHeight)
        ])

        contentStack.addArrangedSubview(titleTextField)
        titleTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight).isActive = true

        // Icon picker row
        buildIconPickerRow()
        contentStack.addArrangedSubview(iconPickerRow)
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: iconPickerRow)
    }

    private func buildWhySection() {
        contentStack.addArrangedSubview(makeSectionLabel("YOUR WHY"))
        contentStack.addArrangedSubview(
            makeHintLabel("What is the soul of this practice?")
        )

        contentStack.addArrangedSubview(purposeField)
        purposeField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight).isActive = true
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: purposeField)
    }

    private func buildWhenSection() {
        contentStack.addArrangedSubview(makeSectionLabel("WHEN"))

        contentStack.addArrangedSubview(scheduleSegment)
        scheduleSegment.heightAnchor.constraint(equalToConstant: 36).isActive = true

        buildDayButtons()
        contentStack.addArrangedSubview(dayButtonsStack)
        dayButtonsStack.heightAnchor.constraint(equalToConstant: Layout.dayButtonSize).isActive = true

        let reminderRow = makeToggleRow(label: "Allow reminders", toggle: reminderSwitch)
        contentStack.addArrangedSubview(reminderRow)

        contentStack.addArrangedSubview(timePicker)

        let anchorHint = makeHintLabel("Anchor this to an existing moment:")
        anchorHabitContainer.addArrangedSubview(anchorHint)
        anchorHabitContainer.addArrangedSubview(anchorHabitField)
        anchorHabitField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight).isActive = true

        contentStack.addArrangedSubview(anchorHabitContainer)
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: anchorHabitContainer)
    }

    // MARK: - Component Builders

    private func makeSectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .compact(size: 13)
        label.textColor = .secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeHintLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .secondary(size: 13)
        label.textColor = .secondaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeStyledTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .body()
        tf.textColor = .primaryText
        tf.backgroundColor = .surface
        tf.layer.cornerRadius = Layout.cornerRadius
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.rightViewMode = .always
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    private func makeToggleRow(label text: String, toggle: UISwitch) -> UIView {
        let card = Card()
        let label = UILabel()
        label.text = text
        label.font = .compact(size: 14)
        label.textColor = .primaryText
        label.translatesAutoresizingMaskIntoConstraints = false

        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .accent
        // Scale the switch down slightly to match the compact row height
        toggle.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        card.addSubview(label)
        card.addSubview(toggle)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 44),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            toggle.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        return card
    }
    
    private func buildSuggestionChips() {
        for (index, suggestion) in suggestions.enumerated() {
            var config = UIButton.Configuration.filled()
            config.title = suggestion.title
            config.image = UIImage(
                systemName: suggestion.icon,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
            )
            config.imagePadding = 6
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            config.cornerStyle = .capsule
            config.baseBackgroundColor = .surface
            config.baseForegroundColor = .primaryText
            config.background.strokeColor = .separator
            config.background.strokeWidth = 0.5
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .compact(size: 14)
                return outgoing
            }

            let btn = UIButton(configuration: config)
            btn.tag = index
            btn.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false

            suggestionStack.addArrangedSubview(btn)
        }
    }

    private func buildIconPickerRow() {
        let iconLabel = UILabel()
        iconLabel.text = "Choose a symbol"
        iconLabel.font = .compact(size: 14)
        iconLabel.textColor = .primaryText
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: chevronConfig))
        chevron.tintColor = .secondaryText
        chevron.translatesAutoresizingMaskIntoConstraints = false

        iconPickerRow.addSubview(selectedIconView)
        iconPickerRow.addSubview(iconLabel)
        iconPickerRow.addSubview(chevron)

        NSLayoutConstraint.activate([
            iconPickerRow.heightAnchor.constraint(equalToConstant: 44),

            selectedIconView.leadingAnchor.constraint(equalTo: iconPickerRow.leadingAnchor, constant: 16),
            selectedIconView.centerYAnchor.constraint(equalTo: iconPickerRow.centerYAnchor),
            selectedIconView.widthAnchor.constraint(equalToConstant: 24),
            selectedIconView.heightAnchor.constraint(equalToConstant: 24),

            iconLabel.leadingAnchor.constraint(equalTo: selectedIconView.trailingAnchor, constant: 12),
            iconLabel.centerYAnchor.constraint(equalTo: iconPickerRow.centerYAnchor),

            chevron.trailingAnchor.constraint(equalTo: iconPickerRow.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: iconPickerRow.centerYAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconPickerTapped))
        iconPickerRow.addGestureRecognizer(tap)
    }

    private func buildDayButtons() {
        for (index, label) in dayLabels.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(label, for: .normal)
            btn.titleLabel?.font = .compact(size: 14)
            btn.tag = index
            btn.layer.cornerRadius = Layout.dayButtonSize / 2
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.separator.cgColor
            btn.backgroundColor = .surface
            btn.setTitleColor(.secondaryText, for: .normal)
            btn.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)

            dayButtons.append(btn)
            dayButtonsStack.addArrangedSubview(btn)
        }
    }

    // MARK: - Actions

    private func setupActions() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)

        [anchorHabitField, purposeField].forEach { $0.delegate = self }

        scheduleSegment.addTarget(self, action: #selector(scheduleChanged), for: .valueChanged)
        reminderSwitch.addTarget(self, action: #selector(reminderToggled), for: .valueChanged)
        commitButton.addTarget(self, action: #selector(commitTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() {
        delegate?.addHabitViewControllerDidCancel(self)
    }

    @objc private func titleTextChanged() {
        updateCommitButtonState()
    }

    @objc private func suggestionTapped(_ sender: UIButton) {
        let suggestion = suggestions[sender.tag]
        titleTextField.text = suggestion.title
        selectIcon(named: suggestion.icon)
        updateCommitButtonState()
    }

    @objc private func iconPickerTapped() {
        let picker = IconPickerViewController(icons: iconOptions, selected: selectedIconName)
        picker.onIconSelected = { [weak self] name in
            self?.selectIcon(named: name)
        }

        let nav = UINavigationController(rootViewController: picker)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(nav, animated: true)
    }

    @objc private func scheduleChanged() {
        let isCustom = scheduleSegment.selectedSegmentIndex == Habit.HabitScheduleType.allCases.firstIndex(of: .custom)
        toggleArrangedSubview(dayButtonsStack, visible: isCustom)
        updateCommitButtonState()
    }

    @objc private func reminderToggled() {
        let isOn = reminderSwitch.isOn
        toggleArrangedSubview(timePicker, visible: isOn)

    }

    @objc private func dayButtonTapped(_ sender: UIButton) {
        let day = sender.tag

        if selectedDays.contains(day) {
            selectedDays.remove(day)
            sender.backgroundColor = .surface
            sender.setTitleColor(.secondaryText, for: .normal)
            sender.layer.borderColor = UIColor.separator.cgColor
        } else {
            selectedDays.insert(day)
            sender.backgroundColor = .accent
            sender.setTitleColor(.baseBackground, for: .normal)
            sender.layer.borderColor = UIColor.accent.cgColor
        }

        updateCommitButtonState()
    }

    // MARK: - Helpers

    private func toggleArrangedSubview(_ subview: UIView, visible: Bool) {
        if visible {
            subview.isHidden = false
            subview.alpha = 0
        }
        UIView.animate(withDuration: 0.25, animations: {
            subview.alpha = visible ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if !visible {
                subview.isHidden = true
            }
        })
    }

    private func selectIcon(named name: String) {
        selectedIconName = name
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        selectedIconView.image = UIImage(systemName: name, withConfiguration: config)
        selectedIconView.tintColor = .accent
    }

    private func trimmedText(_ field: UITextField) -> String? {
        let text = (field.text ?? "").trimmingCharacters(in: .whitespaces)
        return text.isEmpty ? nil : text
    }

    // MARK: - Save

    @objc private func commitTapped() {
        guard let title = titleTextField.text,
              !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        let scheduleType = Habit.HabitScheduleType.allCases[scheduleSegment.selectedSegmentIndex]

        var bitmask: Int16?
        if scheduleType == .custom {
            var mask: Int16 = 0
            for day in selectedDays {
                mask |= (1 << Int16(day))
            }
            bitmask = mask
        }

        let habit = Habit(
            id: UUID(),
            title: title.trimmingCharacters(in: .whitespaces),
            createdAt: Date(),
            isArchived: false,
            scheduledType: scheduleType,
            customDaysBitmask: bitmask,
            reminderEnabled: reminderSwitch.isOn,
            reminderTime: reminderSwitch.isOn ? timePicker.date : nil,
            iconName: selectedIconName,
            anchorHabit: trimmedText(anchorHabitField),
            purposeStatement: trimmedText(purposeField)
        )

        delegate?.addHabitViewController(self, didAdd: habit)
    }

    // MARK: - Validation

    private func updateCommitButtonState() {
        let hasTitle = !(titleTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        let scheduleType = Habit.HabitScheduleType.allCases[scheduleSegment.selectedSegmentIndex]
        let customValid = scheduleType != .custom || !selectedDays.isEmpty

        commitButton.setEnabledState(hasTitle && customValid)
    }
}

// MARK: - UITextFieldDelegate

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Icon Picker Sheet

final class IconPickerViewController: UIViewController {

    var onIconSelected: ((String) -> Void)?

    private let icons: [String]
    private var selected: String?
    private var iconButtons: [UIButton] = []

    private enum PickerLayout {
        static let padding: CGFloat = 20
        static let gridSpacing: CGFloat = 12
        static let iconSize: CGFloat = 48
        static let iconsPerRow: Int = 6
    }

    init(icons: [String], selected: String?) {
        self.icons = icons
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground
        title = "Choose an Icon"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )

        buildGrid()
    }

    private func buildGrid() {
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = PickerLayout.gridSpacing
        grid.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(grid)

        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PickerLayout.padding),
            grid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PickerLayout.padding),
            grid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PickerLayout.padding)
        ])

        var currentRow: UIStackView?

        for (index, name) in icons.enumerated() {
            if index % PickerLayout.iconsPerRow == 0 {
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.distribution = .equalSpacing
                currentRow?.translatesAutoresizingMaskIntoConstraints = false
                grid.addArrangedSubview(currentRow ?? UIStackView())
            }

            let btn = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
            btn.setImage(UIImage(systemName: name, withConfiguration: config), for: .normal)
            btn.layer.cornerRadius = PickerLayout.iconSize / 2
            btn.tag = index
            btn.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                btn.widthAnchor.constraint(equalToConstant: PickerLayout.iconSize),
                btn.heightAnchor.constraint(equalToConstant: PickerLayout.iconSize)
            ])

            let isSelected = name == selected
            btn.backgroundColor = isSelected ? .accent : .clear
            btn.tintColor = isSelected ? .baseBackground : .secondaryText

            iconButtons.append(btn)
            currentRow?.addArrangedSubview(btn)
        }
    }

    @objc private func iconTapped(_ sender: UIButton) {
        let name = icons[sender.tag]
        selected = name

        for (index, btn) in iconButtons.enumerated() {
            let isSelected = icons[index] == name
            UIView.animate(withDuration: 0.15) {
                btn.backgroundColor = isSelected ? .accent : .clear
                btn.tintColor = isSelected ? .baseBackground : .secondaryText
            }
        }

        onIconSelected?(name)
    }

    @objc private func doneTapped() {
        dismiss(animated: true)
    }
}
