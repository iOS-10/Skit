//
//  FeedViewController.swift
//  Skit
//
//  Created by Abdurrahman on 1/31/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	var posts = [Post]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		DataService.ds.REF_POSTS.observe(.value, with: { snapshot in
			self.loadingIndicator.startAnimating()
			self.posts = []
			
			if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshots {
					if let postDict = snap.value as? Dictionary<String, AnyObject> {
						let key = snap.key
						let post = Post(postKey: key, postData: postDict)
						self.posts.append(post)
					}
				}
			}
			self.tableView.reloadData()
			self.loadingIndicator.stopAnimating()
			self.loadingIndicator.isHidden = true
		})
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell {
			cell.configureCell(post: posts[indexPath.row])
			return cell
		}
		return UITableViewCell()
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

}
