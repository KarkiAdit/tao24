//
//  AddHabitViewController.swift
//  tao24
//
//  Created by Aditya Karki on 4/21/26.
//

import UIKit

// MARK: - Delegate Protocol

/// Communicates the result of the Add Habit flow back to the presenting screen.
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
    }

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

    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Habit name"
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
    }()

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

    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.applyStyle(.primary, title: "Save Habit")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - State

    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    private var dayButtons: [UIButton] = []
    private var selectedDays: Set<Int> = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupActions()
        updateSaveButtonState()
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
        // --- Title Section ---
        let titleSection = makeSectionLabel("HABIT NAME")
        contentStack.addArrangedSubview(titleSection)
        contentStack.addArrangedSubview(titleTextField)
        titleTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight).isActive = true
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: titleTextField)

        // --- Schedule Section ---
        let scheduleSection = makeSectionLabel("SCHEDULE")
        contentStack.addArrangedSubview(scheduleSection)
        contentStack.addArrangedSubview(scheduleSegment)
        scheduleSegment.heightAnchor.constraint(equalToConstant: 36).isActive = true

        // Custom day picker row
        buildDayButtons()
        contentStack.addArrangedSubview(dayButtonsStack)
        dayButtonsStack.heightAnchor.constraint(equalToConstant: Layout.dayButtonSize).isActive = true
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: dayButtonsStack)

        // --- Reminder Section ---
        let reminderSection = makeSectionLabel("REMINDER")
        contentStack.addArrangedSubview(reminderSection)

        let reminderRow = makeToggleRow(label: "Enable Reminder", toggle: reminderSwitch)
        contentStack.addArrangedSubview(reminderRow)

        contentStack.addArrangedSubview(timePicker)
        contentStack.setCustomSpacing(Layout.sectionSpacing, after: timePicker)

        // --- Save Button ---
        contentStack.addArrangedSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight).isActive = true
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

    private func makeToggleRow(label text: String, toggle: UISwitch) -> UIView {
        let card = Card()

        let label = UILabel()
        label.text = text
        label.font = .body()
        label.textColor = .primaryText
        label.translatesAutoresizingMaskIntoConstraints = false

        toggle.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(label)
        card.addSubview(toggle)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
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
        scheduleSegment.addTarget(self, action: #selector(scheduleChanged), for: .valueChanged)
        reminderSwitch.addTarget(self, action: #selector(reminderToggled), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() {
        delegate?.addHabitViewControllerDidCancel(self)
    }

    @objc private func titleTextChanged() {
        updateSaveButtonState()
    }

    @objc private func scheduleChanged() {
        let isCustom = scheduleSegment.selectedSegmentIndex == Habit.HabitScheduleType.allCases.firstIndex(of: .custom)
        UIView.animate(withDuration: 0.25) {
            self.dayButtonsStack.isHidden = !isCustom
            self.dayButtonsStack.alpha = isCustom ? 1 : 0
        }
        updateSaveButtonState()
    }

    @objc private func reminderToggled() {
        UIView.animate(withDuration: 0.25) {
            self.timePicker.isHidden = !self.reminderSwitch.isOn
            self.timePicker.alpha = self.reminderSwitch.isOn ? 1 : 0
        }
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

        updateSaveButtonState()
    }

    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
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
            scheduledType: scheduleType,
            customDaysBitmask: bitmask,
            reminderEnabled: reminderSwitch.isOn,
            reminderTime: reminderSwitch.isOn ? timePicker.date : nil,
            createdAt: Date(),
            isArchived: false
        )

        delegate?.addHabitViewController(self, didAdd: habit)
    }

    // MARK: - Validation

    private func updateSaveButtonState() {
        let hasTitle = !(titleTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        let scheduleType = Habit.HabitScheduleType.allCases[scheduleSegment.selectedSegmentIndex]
        let customValid = scheduleType != .custom || !selectedDays.isEmpty

        saveButton.setEnabledState(hasTitle && customValid)
    }
}

// MARK: - UITextFieldDelegate

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
