//
//  SettingsViewController.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import UIKit

/// View controller for app settings
class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    
    // Input fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    // Controls
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    private let settingsKey = "UserSettings"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
        setupKeyboardHandling()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure labels
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        notesLabel.text = "Notes"
        notesLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        notificationsLabel.text = "Enable Notifications"
        notificationsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        fontSizeLabel.text = "Font Size"
        fontSizeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        themeLabel.text = "Theme"
        themeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Configure text fields
        nameTextField.placeholder = "Enter your name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        
        emailTextField.placeholder = "Enter your email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.delegate = self
        
        // Configure text view
        notesTextView.text = "Enter your notes here..."
        notesTextView.font = UIFont.systemFont(ofSize: 16)
        notesTextView.layer.borderColor = UIColor.systemGray4.cgColor
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.cornerRadius = 8
        notesTextView.delegate = self
        
        // Configure switch
        notificationsSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        // Configure slider
        fontSizeSlider.minimumValue = 12
        fontSizeSlider.maximumValue = 24
        fontSizeSlider.value = 16
        fontSizeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        updateFontSizeLabel()
        
        // Configure segmented control
        themeSegmentedControl.setTitle("Light", forSegmentAt: 0)
        themeSegmentedControl.setTitle("Dark", forSegmentAt: 1)
        themeSegmentedControl.setTitle("Auto", forSegmentAt: 2)
        themeSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Configure stack view
        mainStackView.spacing = 20
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        
        // Add save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveSettings)
        )
    }
    
    private func setupKeyboardHandling() {
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Observe keyboard notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged() {
        saveSettings()
    }
    
    @objc private func sliderValueChanged() {
        updateFontSizeLabel()
        saveSettings()
    }
    
    @objc private func segmentedControlValueChanged() {
        saveSettings()
    }
    
    @objc private func saveSettings() {
        let settings: [String: Any] = [
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "notes": notesTextView.text ?? "",
            "notificationsEnabled": notificationsSwitch.isOn,
            "fontSize": fontSizeSlider.value,
            "theme": themeSegmentedControl.selectedSegmentIndex
        ]
        
        UserDefaults.standard.set(settings, forKey: settingsKey)
        
        // Show save confirmation
        showSaveConfirmation()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Helper Methods
    private func updateFontSizeLabel() {
        let fontSize = Int(fontSizeSlider.value)
        fontSizeLabel.text = "Font Size: \(fontSize)pt"
    }
    
    private func loadSettings() {
        guard let settings = UserDefaults.standard.dictionary(forKey: settingsKey) else {
            return
        }
        
        nameTextField.text = settings["name"] as? String
        emailTextField.text = settings["email"] as? String
        notesTextView.text = settings["notes"] as? String ?? "Enter your notes here..."
        notificationsSwitch.isOn = settings["notificationsEnabled"] as? Bool ?? false
        
        if let fontSize = settings["fontSize"] as? Float {
            fontSizeSlider.value = fontSize
            updateFontSizeLabel()
        }
        
        if let theme = settings["theme"] as? Int {
            themeSegmentedControl.selectedSegmentIndex = theme
        }
    }
    
    private func showSaveConfirmation() {
        let alert = UIAlertController(title: "Settings Saved", message: "Your settings have been saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        // Auto-dismiss after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveSettings()
    }
}

// MARK: - UITextViewDelegate
extension SettingsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your notes here..." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your notes here..."
            textView.textColor = .placeholderText
        }
        saveSettings()
    }
}


