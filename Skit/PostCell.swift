//
//  PostCell.swift
//  Skit
//
//  Created by Abdurrahman on 2/1/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var postImg: UIImageView!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	var post: Post!
	
	func configureCell(post: Post, image: UIImage?) {
		self.post = post
		likesLabel.text = "\(post.likes) Likes"
		descriptionLabel.text = "\(post.caption)"
		
		if image != nil {
			self.postImg.image = image
		} else {
			let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
			ref.data(withMaxSize: 4 * 5000 * 5000, completion: { (data, error) in
				if error != nil {
					print("Unable to download image from firebase storage")
				} else {
					print("Image downloaded from firebase storage")
					if let imgData = data {
						if let img = UIImage(data: imgData) {
							self.postImg.image = img
							FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl as NSString)
						}
					}
				}
			})
		}
	}

}
