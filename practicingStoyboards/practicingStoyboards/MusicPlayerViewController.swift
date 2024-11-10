//
//  MusicPlayerViewController.swift
//  practicingStoyboards
//
//  Created by Miguel on 9/11/24.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var symbolImageViewTrackTop: UIButton!
    @IBOutlet weak var symbolImageViewTrackBottom: UIButton!
    
    private var paused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeSymbolWithAnimation(button: UIButton, newSymbol: String) {
        let newImage = UIImage(systemName: newSymbol)
        
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
            button.setImage(newImage, for: .normal)
        }, completion: nil)
    }
    
    func onTogglePlayPause() {
        if self.paused {
            changeSymbolWithAnimation(button: symbolImageViewTrackTop, newSymbol: "pause.fill")
            changeSymbolWithAnimation(button: symbolImageViewTrackBottom, newSymbol: "pause.fill")
            self.paused.toggle()
        } else {
            changeSymbolWithAnimation(button: symbolImageViewTrackTop, newSymbol: "play.fill")
            changeSymbolWithAnimation(button: symbolImageViewTrackBottom, newSymbol: "play.fill")
            self.paused.toggle()
        }
    }
    
    @IBAction func onPlayPauseButtonDidPress() {
        onTogglePlayPause()
    }
}
