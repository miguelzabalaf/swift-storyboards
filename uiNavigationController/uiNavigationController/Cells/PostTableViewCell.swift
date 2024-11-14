//
//  PostTableViewCell.swift
//  uiNavigationController
//
//  Created by Miguel on 12/11/24.
//

import UIKit

struct Post {
    let username: String
    let location: String
    let profileImage: UIImage
    let postImage: UIImage
    let description: String
    let date: String
}

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProfileImage()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupProfileImage() {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    private func setupDescriptionLabel(with username: String, and description: String) {
        let usernameAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .semibold)]
        
        let descriptionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        
        // Create two texts with differents attributes
        let attributedUsername = NSAttributedString(string: username, attributes: usernameAttributes)
        
        let attributedDescription = NSAttributedString(string: " \(description)", attributes: descriptionAttributes)
        
        // Combine both in a NSMutableAttributedString
        let fullAttributedText = NSMutableAttributedString()
        fullAttributedText.append(attributedUsername)
        fullAttributedText.append(attributedDescription)
        
        // Asignar el texto atribuido a descriptionLabel
        descriptionLabel.attributedText = fullAttributedText
    }
    
    func setupCell(with post: Post) {
        usernameLabel.text = post.username
        locationLabel.text = post.location
        profileImage.image = post.profileImage
        postImage.image = post.postImage
        setupDescriptionLabel(with: post.username, and: post.description)
        dateLabel.text = post.date
    }
    
}
