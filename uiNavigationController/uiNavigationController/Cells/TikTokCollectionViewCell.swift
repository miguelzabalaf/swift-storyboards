//
//  TikTokCollectionViewCell.swift
//  uiNavigationController
//
//  Created by Miguel on 14/11/24.
//

import UIKit
import AVFoundation
import AVKit

struct TiktokState {
    var isplaying: Bool
    var isDragging: Bool
}


class TikTokCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var labelsContainer: UIStackView!
    @IBOutlet weak var actionsContainer: UIView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    var state: TiktokState = .init(isplaying: true, isDragging: false)
    var data: TikTokData?
    var isTheFirstVideo: Bool = false
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerLayer?.frame = videoView.bounds
        self.playImage.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoView.bounds
    }
    
    public func setupTikTokData(with data: TikTokData, isTheFistVideo: Bool = false) {
        self.userLabel.text = data.user
        self.descriptionLabel.text = data.description
        self.profileImage.image = data.profileImage
        self.data = data
        self.isTheFirstVideo = isTheFistVideo
        setupVideo(with: data.videoName)
    }
    
    public func setupVideo(with videoName: String) {
        guard let filePath = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            print("Error: Video \(videoName).mov not found in bundle.")
            return
        }
        self.player = AVPlayer(url: URL(fileURLWithPath: filePath))
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = videoView.bounds
        self.playerLayer?.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer!)
                
        // Add observer
        player?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: self.player?.currentItem
        )
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            guard let currentPlayer = object as? AVPlayer else { return }
            if self.player?.status == .readyToPlay {
                print("Video ready to play.")
                if self.isTheFirstVideo {
                    currentPlayer.play()
                }
            } else if self.player?.status == .failed {
                print("Error loading video: \(String(describing: self.player?.error))")
            }
        }
    }
    
    @objc public func restartVideo() {
        player?.seek(to: .zero) // Reinicia el video al inicio
        player?.play() // Vuelve a reproducir
        setIsPlaying(true)
        print("restartVideo executed")
    }
    
    public func restartSeek() {
        player?.seek(to: .zero)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player = nil
        playerLayer = nil
    }
    
    private func hidePlayImage() {
        self.playImage.isHidden = true
    }
    
    private func showPlayImage() {
        self.playImage.isHidden = false
    }
    
    private func playVideo() {
        self.player?.play()
    }
    
    private func pauseVideo() {
        self.player?.pause()
    }

    @IBAction func centerButtonDidPress(_ sender: Any) {
        self.state.isplaying ? showPlayImage() : hidePlayImage()
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
    
    public func onPreviousCellConfiguration() {
        self.restartSeek()
        self.pauseVideo()
        self.hidePlayImage()
    }
    
    public func onVisibleCellConfiguration() {
        self.playVideo()
        self.hidePlayImage()
    }
}
