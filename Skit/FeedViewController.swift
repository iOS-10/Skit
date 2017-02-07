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
	@IBOutlet weak var postImg: UIImageView!
	@IBOutlet weak var captionTextField: UITextField!
	
	var posts = [Post]()
	var picker: UIImagePickerController!
	static var imageCache: NSCache<NSString, UIImage> = NSCache()
	var imagePicked = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		
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
	
	@IBAction func pickImageBtnPressed(_ sender: UIButton) {
		present(picker, animated: true, completion: nil)
	}
	
	@IBAction func postBtnPressed(_ sender: Any) {
		guard let caption = captionTextField.text, caption != "" else {
			print("Text needed")
			return
		}
		
		guard let img = postImg.image, imagePicked == true else {
			print("Attach a pic")
			return
		}
		
		if let imgData = UIImageJPEGRepresentation(img, 0.2) {
			let imgUID = NSUUID().uuidString
			let metaData = FIRStorageMetadata()
			metaData.contentType = "image/jpeg"
			
			DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metaData) { (metadata, error) in
				if error != nil {
					print("Can't upload your image")
				} else {
					print("Successfully uploaded image to Firebase Storage")
					let downloadUrl = metadata?.downloadURL()?.absoluteString
					if let url = downloadUrl {
						self.postToFirebase(imgUrl: url)
					}
				}
			}
		}
	}
	
	func postToFirebase(imgUrl: String) {
		let post: Dictionary<String, AnyObject> = [
			"caption": captionTextField.text! as AnyObject,
			"imageUrl": imgUrl as AnyObject,
			"likes": 0 as AnyObject
		]
		
		let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
		firebasePost.setValue(post)
		
		captionTextField.text = ""
		imagePicked = false
		postImg.image = UIImage(named: "placeholder.png")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let post = posts[indexPath.row]
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell {
		
			if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
				cell.configureCell(post: posts[indexPath.row], image: img)
				return cell
			} else {
				cell.configureCell(post: post, image: nil)
				return cell
			}
		}
		return UITableViewCell()
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

}







