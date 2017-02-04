//
//  SignInViewController.swift
//  Skit
//
//  Created by Abdurrahman on 1/31/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
			performSegue(withIdentifier: "showFeed", sender: nil)
		} else {
			print("not logged in")
		}
	}

	@IBAction func logIn(_ sender: Any) {
		if let email = emailField.text, let password = passwordField.text {
			if email != "" && password != "" {
				FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
					if error == nil {
						print("Success!")
						print("Email: \(email)")
						print("Password: \(password)")
						if let user = user {
							let userData = ["provider": user.providerID]
							self.completeSignIn(id: user.uid, userData: userData)
						}
						self.emailField.text = ""
						self.passwordField.text = ""
						self.view.endEditing(true)
					} else {
						print("Error, maybe the user doesn't exist")
						self.view.endEditing(true)
					}
				})
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		if let email = emailField.text, let password = passwordField.text {
			if email != "" && password != "" {
				FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
					if error != nil {
						print("Error, the user couldn't be created")
						self.view.endEditing(true)
					} else {
						print("Welcome, your account has been created!")
						print("Your Email: \(email)")
						print("Your Password: \(password)")
						if let user = user {
							let userData = ["provider": user.providerID]
							self.completeSignIn(id: user.uid, userData: userData)
						}
						self.emailField.text = ""
						self.passwordField.text = ""
						self.view.endEditing(true)
					}
				})
			}
		}
	}
	
	func completeSignIn(id: String, userData: Dictionary<String, String>) {
		DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
		KeychainWrapper.standard.set(id, forKey: KEY_UID)
		performSegue(withIdentifier: "showFeed", sender: nil)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
}

