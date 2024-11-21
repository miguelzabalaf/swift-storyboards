//
//  CustomAnimatedBottomTabViewController.swift
//  AdvancedLayout
//
//  Created by Miguel on 19/11/24.
//

import UIKit

enum OptionTab: String {
    case home = "Home"
    case grid = "Grid"
    case chart = "Chart"
    case person = "Person"
}

class CustomAnimatedBottomTabViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var bottomTabContainer: UIView!
    @IBOutlet weak var bottomTabExpandedContainer: UIView!
    @IBOutlet weak var bottomTabExpandedContainerLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomTabExpandedContainerTrailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomTabExpandedContainerBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomTabHSTackView: UIStackView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var expandBottomTabSwitch: UISwitch!
    @IBOutlet weak var expandBottomTabLabel: UILabel!
    
    private var isExpandedBottomTab: Bool = false
    
    // barIndicator
    private var barIndicator: UIView = UIView()
    private var barIndicatorHeightConstraint: NSLayoutConstraint?
    private var barIndicatorWidthConstraint: NSLayoutConstraint?
    private var barIndicatorCenterXConstraint: NSLayoutConstraint?
    private var barIndicatorBottomConstraint: NSLayoutConstraint?
    
    private var selectedTab: OptionTab = .home {
        didSet {
            self.onSetupTabs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.onSetupTabs()
        self.onSetupBarIndicator(by: self.homeButton)
    }
    
    
    private func onSetupTabs() {
        self.bottomTabHSTackView.subviews.forEach { (tab) in
            if let tab = tab as? UIButton, let identifier = tab.accessibilityIdentifier {
                UIView.animate(withDuration: 0.5) {
                    tab.tintColor = identifier == self.selectedTab.rawValue ? .tintColor : .gray
                }
            }
        }
    }
    
    private func onSetupBarIndicator(by selectedButton: UIButton) {
        self.barIndicator.backgroundColor = .tintColor
        if self.barIndicator.superview == nil {
            self.bottomTabExpandedContainer.addSubview(self.barIndicator)
            self.barIndicator.translatesAutoresizingMaskIntoConstraints = false

            // Constraints fijas
            barIndicatorHeightConstraint = self.barIndicator.heightAnchor.constraint(equalToConstant: 3)
            barIndicatorWidthConstraint = self.barIndicator.widthAnchor.constraint(equalToConstant: 25)

            NSLayoutConstraint.activate([
                barIndicatorHeightConstraint!,
                barIndicatorWidthConstraint!
            ])
        }

        // Actualizar o configurar constraints dinámicas
        barIndicatorCenterXConstraint?.isActive = false
        barIndicatorBottomConstraint?.isActive = false

        barIndicatorCenterXConstraint = self.barIndicator.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        barIndicatorBottomConstraint = self.barIndicator.bottomAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: 5)
        
        NSLayoutConstraint.activate([
            barIndicatorCenterXConstraint!,
            barIndicatorBottomConstraint!
        ])
        
        // Animar el cambio si es necesario
        animate(view: self.bottomTabExpandedContainer)
    }
    
    private func onExpandBottomTabSetup(expand: Bool) {
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = self.bottomTabExpandedContainer.layer.cornerRadius
        cornerRadiusAnimation.toValue = expand ? 0 : 32
        cornerRadiusAnimation.duration = 0.3
        self.bottomTabExpandedContainer.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
        self.bottomTabExpandedContainer.layer.cornerRadius = expand ? 0 : 32

        self.bottomTabExpandedContainerLeadingConstraints.isActive = false
        self.bottomTabExpandedContainerTrailingConstraints.isActive = false
        self.bottomTabExpandedContainerBottomConstraints.isActive = false
        
        self.bottomTabExpandedContainerLeadingConstraints = self.bottomTabExpandedContainer.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: expand ? 0 : 32)
        self.bottomTabExpandedContainerTrailingConstraints = self.bottomTabExpandedContainer.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: expand ? 0 : -32)
        self.bottomTabExpandedContainerBottomConstraints = bottomTabExpandedContainer.bottomAnchor.constraint(equalTo: expand ? self.mainView.bottomAnchor : self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            self.bottomTabExpandedContainerLeadingConstraints,
            self.bottomTabExpandedContainerTrailingConstraints,
            self.bottomTabExpandedContainerBottomConstraints
        ])
        
        animate(view: self.bottomTabContainer)

    }
    
    private func animate(view: UIView) {
        UIView.animate(
            withDuration: 1,          // Duración de la animación
            delay: 0,                   // Sin retraso
            usingSpringWithDamping: 1, // Damping (0 = rebote completo, 1 = sin rebote)
            initialSpringVelocity: 1.0, // Velocidad inicial del spring
            options: [.curveEaseOut], // Opciones de animación
            animations: {
                view.layoutIfNeeded() // Aplica los cambios a las constraints
            },
            completion: nil             // Sin acción al finalizar
        )
    }
    
    @IBAction func onSelectTab(_ sender: UIButton, forEvent event: UIEvent) {
        guard let identifier = sender.accessibilityIdentifier, let selectedOption = OptionTab(rawValue: identifier) else {
            assertionFailure("Set the accessibilityIdentifier for the tab button")
            return
        }
        self.selectedTab = selectedOption
        self.onSetupBarIndicator(by: sender)
    }
    

    @IBAction func onExpandBottomTab(_ sender: UISwitch) {
        self.isExpandedBottomTab = sender.isOn
        self.expandBottomTabLabel.textColor = sender.isOn ? .systemGreen : .systemGray
        self.onExpandBottomTabSetup(expand: sender.isOn)
    }
}
