//
//  TikTokCollectionViewCell.swift
//  uiNavigationController
//
//  Created by Miguel on 14/11/24.
//

import UIKit

struct TiktokState {
    var isplaying: Bool
    var isDragging: Bool
}


class TikTokCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var labelsContainer: UIStackView!
    @IBOutlet weak var actionsContainer: UIView!
    @IBOutlet weak var centerButton: UIButton!
    
    var state: TiktokState = .init(isplaying: true, isDragging: false)
    var data: TikTokData?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setupTikTokData(with data: TikTokData) {
        self.userLabel.text = data.user
        self.descriptionLabel.text = data.description
        self.profileImage.image = data.profileImage
        self.postImage.image = data.postImage
    }
    
    private func hidePlayImage() {
        self.playImage.isHidden = true
    }
    
    private func showPlayImage() {
        self.playImage.isHidden = false
    }
    
    private func playVideo() {
        hidePlayImage()
    }
    
    private func pauseVideo() {
        showPlayImage()
    }

    @IBAction func centerButtonDidPress(_ sender: Any) {
        self.setIsPlaying(!self.state.isplaying)
    }
}

extension TikTokCollectionViewCell {
    private func modifyLayer(opacity value: Float) {
        self.labelsContainer.layer.opacity = value
        self.actionsContainer.layer.opacity = value
    }
    
    public func setIsPlaying(_ isPlaying: Bool) {
        self.state.isplaying = isPlaying
        isPlaying ? playVideo() : pauseVideo()
    }
    
    public func setIsDragging(_ isDragging: Bool) {
        self.state.isDragging = isDragging
        modifyLayer(opacity: isDragging ? 0.5 : 1)
    }
}
