//
//  FeedViewController.swift
//  Skit
//
//  Created by Abdurrahman on 1/31/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

	}
	
	@IBAction func signOut(_ sender: Any) {
		try! FIRAuth.auth()?.signOut()
		
		dismiss(animated: true, completion: nil)
	}

}
