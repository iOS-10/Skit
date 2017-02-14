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
import PopupDialog

class SignInViewController: UIViewController {

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var usernameField: UITextField!
	
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
						self.alert(title: "Error", message: "Something went wrong", withCancel: false)
						self.view.endEditing(true)
					}
				})
			} else {
				alert(title: "Error", message: "All fields are required", withCancel: false)
			}
		} else {
			alert(title: "Error", message: "All fields are required", withCancel: false)
		}
	}

	@IBAction func signUp(_ sender: Any) {
		if let email = emailField.text, let password = passwordField.text, let username = usernameField.text {
			if email != "" && password != "" && username != "" {
				FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
					if error != nil {
						print("Error, the user couldn't be created")
						self.alert(title: "Error", message: "Something went wrong, make sure your password contains at least 6 characters", withCancel: false)
						self.view.endEditing(true)
						print(error.debugDescription)
					} else {
						print("Welcome, your account has been created!")
						print("Your Email: \(email)")
						print("Your Password: \(password)")
						if let user = user {
							let userData = ["provider": user.providerID,
							                "username": username,
											"password": password]
							self.completeSignIn(id: user.uid, userData: userData)
						}
						self.emailField.text = ""
						self.passwordField.text = ""
						self.usernameField.text = ""
						self.view.endEditing(true)
					}
				})
			} else {
				alert(title: "Error", message: "All fields are required", withCancel: false)
			}
		} else {
			alert(title: "Error", message: "All fields are required", withCancel: false)
		}
	}
	
	func completeSignIn(id: String, userData: Dictionary<String, String>) {
		DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
		KeychainWrapper.standard.set(id, forKey: KEY_UID)
		performSegue(withIdentifier: "showFeed", sender: nil)
	}
	
	func alert(title: String, message: String, withCancel: Bool) {
		let popup = PopupDialog(title: title, message: message)
		popup.transitionStyle = .bounceDown
		popup.buttonAlignment = .vertical
		
		if withCancel {
			let cancel = CancelButton(title: "cancel") {
				print("Cancelled")
			}
			
			let ok = DefaultButton(title: "OK") {
				print("Okayeeed!")
			}
			
			popup.addButtons([cancel, ok])
		} else {
			let ok = DefaultButton(title: "OK") {
				print("Dismissed")
			}
			
			popup.addButtons([ok])
		}
		
		self.present(popup, animated: true, completion: nil)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
}

