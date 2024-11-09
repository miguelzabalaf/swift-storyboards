//
//  ViewController.swift
//  practicingStoyboards
//
//  Created by Miguel on 8/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!

    var counter: Int = 0 {
        didSet {
            setValues()
            validate(decrementButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        validate(decrementButton)
    }
    
    func setValues() -> Void {
        self.counterLabel.text = String(counter)
    }
    
    func validate(_ button: UIButton) {
        if counter == 0 {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    @IBAction func incrementButtonDidPress() {
        counter += 1
    }
    
    @IBAction func decrementButtonDidPress() {
        counter -= 1
    }
    
    @IBAction func resetButtonDidPress() {
        counter = 0
    }
}

