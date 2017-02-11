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

	let uid = FIRAuth.auth()?.currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		emailField.text = FIRAuth.auth()?.currentUser?.email
		DataService.ds.REF_USERS.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let snap = snapshot.value as? Dictionary<String, AnyObject> {
				if let username = snap["username"], let password = snap["password"] {
					self.usernameField.text = "\(username)"
					self.passwordField.text = "\(password)"
				}
			}
		})
	}
	
	@IBAction func savePressed(_ sender: Any) {
		if let username = usernameField.text, let email = emailField.text, let password = passwordField.text {
			if username != "" && email != "" && password != "" {
				let updatedData = ["username": username, "password": password]
				DataService.ds.REF_USERS.child(uid!).updateChildValues(updatedData)
				FIRAuth.auth()?.currentUser?.updateEmail(email, completion: nil)
				FIRAuth.auth()?.currentUser?.updatePassword(password, completion: nil)
			}
		}
	}
	
	@IBAction func changeImagePressed(_ sender: Any) {
		
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
