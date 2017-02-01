//
//  ViewController.swift
//  Skit
//
//  Created by Abdurrahman on 1/31/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	@IBAction func logIn(_ sender: Any) {
		if let email = emailField.text, let password = passwordField.text {
			if email != "" && password != "" {
				FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
					if error == nil {
						print("Success!")
						print("Email: \(email)")
						print("Password: \(password)")
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
						self.emailField.text = ""
						self.passwordField.text = ""
						self.view.endEditing(true)
					}
				})
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
}

