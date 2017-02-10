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
	@IBOutlet weak var likeImg: UIImageView!

	var post: Post!
	var likesRef: FIRDatabaseReference!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped))
		tapGesture.numberOfTapsRequired = 1
		likeImg.addGestureRecognizer(tapGesture)
		likeImg.isUserInteractionEnabled = true
	}
	
	func configureCell(post: Post, image: UIImage?) {
		self.post = post
		likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
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
		
		likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				self.likeImg.image = UIImage(named: "like-empty")
			} else {
				self.likeImg.image = UIImage(named: "like-filled")
			}
		})
	}

	func likeTapped(sender: UITapGestureRecognizer) {
		likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				self.likeImg.image = UIImage(named: "like-filled")
				self.post.adjustLikes(addLike: true)
				self.likesRef.setValue(true)
			} else {
				self.likeImg.image = UIImage(named: "like-empty")
				self.post.adjustLikes(addLike: false)
				self.likesRef.removeValue()
			}
		})
	}

}




