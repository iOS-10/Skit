//
//  ProfileViewController.swift
//  Skit
//
//  Created by Abdurrahman on 2/1/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var bgImage: UIImageView!

	let uid = FIRAuth.auth()?.currentUser?.uid
	var picker: UIImagePickerController!
	
	static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
		profileImg.clipsToBounds = true
		picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		
		downloadInfo()
	}
	
	func downloadInfo() {
		emailField.text = FIRAuth.auth()?.currentUser?.email
		DataService.ds.REF_USERS.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let snap = snapshot.value as? Dictionary<String, AnyObject> {
				if let username = snap["username"], let password = snap["password"], let profileImgUrl = snap["profileImgUrl"] {
					self.usernameField.text = "\(username)"
					self.passwordField.text = "\(password)"
					
					let ref = FIRStorage.storage().reference(forURL: profileImgUrl as! String)
					ref.data(withMaxSize: 4 * 5000 * 5000, completion: { (data, error) in
						if error != nil {
							print("Unable to download image from firebase storage")
						} else {
							print("Image downloaded from firebase storage")
							if let imgData = data {
								if let img = UIImage(data: imgData) {
									self.profileImg.image = img
								}
							}
						}
					})
				}
			}
		})
		bgImage.image = profileImg.image
	}
	
	@IBAction func savePressed(_ sender: Any) {
		if let username = usernameField.text, let email = emailField.text, let password = passwordField.text {
			if username != "" && email != "" && password != "" {
			
				guard let img = profileImg.image else {
					print("Attach a pic")
					return
				}
				
				if let imgData = UIImageJPEGRepresentation(img, 0.2) {
					let imgUID = NSUUID().uuidString
					let metaData = FIRStorageMetadata()
					metaData.contentType = "image/jpeg"
					
					DataService.ds.REF_PROFILE_IMAGES.child(uid!).child(imgUID).put(imgData, metadata: metaData) { (metaData, error) in
						if error != nil {
							print("Can't upload your profile picture")
						} else {
							print("Wohoo! Your profile pic was uploaded!")
							let downloadUrl = metaData?.downloadURL()?.absoluteString
							if let url = downloadUrl {
								self.saveInfo(username: username, password: password, email: email, imageUrl: url)
							}
						}
					}
				}
			}
		}
	}
	
	func saveInfo(username: String, password: String, email: String, imageUrl: String) {
		let data: Dictionary<String, String> = [
			"username": username,
			"password": password,
			"profileImgUrl": imageUrl
		]
		
		DataService.ds.REF_USER_CURRENT.updateChildValues(data)
		FIRAuth.auth()?.currentUser?.updateEmail(email, completion: nil)
		FIRAuth.auth()?.currentUser?.updatePassword(password, completion: nil)
	}
	
	@IBAction func changeImagePressed(_ sender: Any) {
		present(picker, animated: true, completion: nil)
	}
	
	@IBAction func signOut(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: KEY_UID)
		try! FIRAuth.auth()?.signOut()
		dismiss(animated: true, completion: nil)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

}
