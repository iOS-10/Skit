//
//  PostCell.swift
//  Skit
//
//  Created by Abdurrahman on 2/1/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var postImg: UIImageView!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	var post: Post!
	
	func configureCell(post: Post) {
		self.post = post
		likesLabel.text = "\(post.likes) Likes"
		descriptionLabel.text = "\(post.caption)"
	}

}
