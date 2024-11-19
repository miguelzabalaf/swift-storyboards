//
//  ModifyConstraintsViewController.swift
//  AdvancedLayout
//
//  Created by Miguel on 18/11/24.
//

import UIKit

class ModifyConstraintsViewController: UIViewController {
    
    @IBOutlet weak var yellowView: UIView!
    
    // Constraints
    var yellowHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupYellowView()
    }
    
    private func setupYellowView() {
        // Disabled automatic constraints
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add some styles
        yellowView.layer.cornerRadius = 10
        yellowView.layer.masksToBounds = true
        yellowView.layer.borderWidth = 1

        // Create necessary constraints
        yellowHeightConstraint = yellowView.heightAnchor.constraint(equalToConstant: 200)
        let widthConstraint = yellowView.widthAnchor.constraint(equalToConstant: 100)
        let topConstraint = yellowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        let leadingConstraint = yellowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let trailingConstraint = yellowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        
        // Add yellowView constsaints
        NSLayoutConstraint.activate([
            yellowHeightConstraint,
            widthConstraint,
            topConstraint,
            leadingConstraint,
            trailingConstraint,
        ])
        
        // Create new View
        let childBoxRed = UIView()
        
        // Add some styles
        childBoxRed.backgroundColor = .red
        childBoxRed.layer.cornerRadius = 5
        childBoxRed.layer.masksToBounds = true
        
        // Disabled automatic constraints
        childBoxRed.translatesAutoresizingMaskIntoConstraints = false
        
        // Create size constraints
        let childBoxRedHeightConstraint = childBoxRed.heightAnchor.constraint(equalToConstant: 50)
        let childBoxRedWidthConstraint = childBoxRed.widthAnchor.constraint(equalToConstant: 50)
        
        // Add sub view to yellow View
        yellowView.addSubview(childBoxRed)
        
        let childBoxRedCenterXConstraint = childBoxRed.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor)
        let childBoxRedCenterYConstraint = childBoxRed.centerYAnchor.constraint(equalTo: yellowView.centerYAnchor)
        
        NSLayoutConstraint.activate([
            childBoxRedHeightConstraint,
            childBoxRedWidthConstraint,
            childBoxRedCenterXConstraint,
            childBoxRedCenterYConstraint
        ])
        
        let childBoxBlue = UIView()
        
        childBoxBlue.backgroundColor = .blue
        
        childBoxBlue.translatesAutoresizingMaskIntoConstraints = false
        
        let childBoxBlueHeightConstraint = childBoxBlue.heightAnchor.constraint(equalTo: yellowView.heightAnchor, constant: 0)
        let childBoxBlueWidthConstraint = childBoxBlue.widthAnchor.constraint(equalToConstant: 50)
        let childBoxBlueTrailingConstraint = childBoxBlue.trailingAnchor.constraint(equalTo: yellowView.trailingAnchor, constant: 0)
        let childBoxBlueTopConstraint = childBoxBlue.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: 0)
        let childBoxBlueBottomConstraint = childBoxBlue.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor, constant: 0)
        
        yellowView.addSubview(childBoxBlue)
        
        NSLayoutConstraint.activate([
            childBoxBlueHeightConstraint,
            childBoxBlueWidthConstraint,
            childBoxBlueTrailingConstraint,
            childBoxBlueTopConstraint,
            childBoxBlueBottomConstraint
        ])
        
        let buttonUp = UIButton()
        buttonUp.setTitle("+10", for: .normal)
        buttonUp.addTarget(self, action: #selector(buttonUpTapped), for: .touchUpInside)
        
        let buttonDown = UIButton()
        buttonDown.setTitle("-10", for: .normal)
        buttonDown.addTarget(self, action: #selector(buttonDownTapped), for: .touchUpInside)
        
        let verticalButtonStackView = UIStackView(arrangedSubviews: [buttonUp, buttonDown])
        verticalButtonStackView.axis = .vertical
        verticalButtonStackView.spacing = 10
        verticalButtonStackView.alignment = .fill
        verticalButtonStackView.distribution = .fillEqually
        verticalButtonStackView.backgroundColor = .black
        
        verticalButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalButtonStackViewHeightConstraint = verticalButtonStackView.heightAnchor.constraint(equalTo: yellowView.heightAnchor)
        let verticalButtonStackViewWidhtConstraint = verticalButtonStackView.widthAnchor.constraint(equalToConstant: 50)
        let verticalButtonStackViewLeadingConstraint = verticalButtonStackView.leadingAnchor.constraint(equalTo: yellowView.leadingAnchor, constant: 0)
        let verticalButtonStackViewTopConstraint = verticalButtonStackView.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: 0)
        let verticalButtonStackViewBottomConstraint = verticalButtonStackView.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor, constant: 0)

        yellowView.addSubview(verticalButtonStackView)
        
        NSLayoutConstraint.activate([
            verticalButtonStackViewHeightConstraint, verticalButtonStackViewWidhtConstraint, verticalButtonStackViewLeadingConstraint, verticalButtonStackViewTopConstraint, verticalButtonStackViewBottomConstraint
        ])

    }
    
    @objc private func buttonUpTapped() {
        UIView.animate(withDuration: 0.25) {
            self.yellowHeightConstraint.constant += 10
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func buttonDownTapped() {
        UIView.animate(withDuration: 0.25) {
            self.yellowHeightConstraint.constant -= 10
            self.view.layoutIfNeeded()
        }
    }
    
}
