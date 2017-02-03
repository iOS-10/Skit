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

    override func viewDidLoad() {
        super.viewDidLoad()
		emailField.text = FIRAuth.auth()?.currentUser?.email
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
