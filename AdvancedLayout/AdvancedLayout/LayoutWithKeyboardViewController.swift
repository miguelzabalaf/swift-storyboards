//
//  LayoutWithKeyboardViewController.swift
//  AdvancedLayout
//
//  Created by Miguel on 20/11/24.
//

import UIKit

class LayoutWithKeyboardViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var centeredLabel: UILabel!
    @IBOutlet weak var bottomSectionContainer: UIView!
    @IBOutlet weak var bottomSectionContainerHStack: UIStackView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonSend: UIView!
    
    private var isShowingSendButton: Bool = false
    
    // Constraints
    @IBOutlet weak var contentViewBottomConstraints: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setups
        self.setupObservers()
        self.setupTextField()
        self.setupCenteredLabel()
        self.setupButtonSend()
        // Delegates
        self.textField.delegate = self
    }
    
    // Delete my specific observers to avoid memory leaks
    deinit {
        self.removeObservers()
    }
    

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextField() {
        self.textField.attributedPlaceholder = NSAttributedString( string: "Type here", attributes: [.foregroundColor: UIColor.lightGray] )
    }
    
    private func setupCenteredLabel() {
        self.centeredLabel.text = ""
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        // Actualiza la constante del constraint
        contentViewBottomConstraints.constant = keyboardFrame.height + 16

        // Convierte el valor de la curva a UIView.AnimationOptions
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

        // Aplica una animación fluida
        animateConstraints(view: self.view, duration: animationDuration, curve: animationCurve)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }

        // Restaura el constraint
        contentViewBottomConstraints.constant = 0

        // Convierte el valor de la curva a UIView.AnimationOptions
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

        // Aplica una animación fluida
        animateConstraints(view: self.view, duration: animationDuration, curve: animationCurve)
    }}

// MARK: - Animations
extension LayoutWithKeyboardViewController {
    private func animateConstraints(view: UIView, duration: Double, curve: UIView.AnimationOptions) {
        UIView.animate(
            withDuration: duration, // Duración dinámica
            delay: 0,               // Sin retraso
            options: curve,         // Curva de animación personalizada
            animations: {
                view.layoutIfNeeded() // Aplica los cambios de Auto Layout
            },
            completion: nil
        )
    }
}

// MARK: - UITextFieldDelegate
extension LayoutWithKeyboardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        self.centeredLabel.text = updatedText
        if updatedText.isEmpty, isShowingSendButton == true {
            self.hideSendButton()
        } else if !updatedText.isEmpty, isShowingSendButton == false {
            self.showSendButton()
        }
        return true
    }
}

// MARK: - Button Send
extension LayoutWithKeyboardViewController {
    private func setupButtonSend() {
        self.hideSendButton()
    }
    
    private func showSendButton() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.buttonSend.transform = .identity
                self.buttonSend.layer.opacity = 1
                self.buttonSend.isHidden = false
                self.bottomSectionContainerHStack.layoutIfNeeded()            },
            completion: nil
        )
        self.isShowingSendButton = true
    }
    
    private func hideSendButton() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.buttonSend.transform = .init(translationX: 25, y: 0)
                self.buttonSend.layer.opacity = 0
                self.buttonSend.isHidden = true
                self.bottomSectionContainerHStack.layoutIfNeeded()            },
            completion: {_ in
                
            }
        )
        self.isShowingSendButton = false
    }

}
