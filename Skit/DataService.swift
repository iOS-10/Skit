//
//  DataService.swift
//  Skit
//
//  Created by Abdurrahman on 2/1/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class DataService {
	
	static let ds = DataService()
	
	// Databse References
	private var _REF_BASE = DB_BASE
	private var _REF_POSTS = DB_BASE.child("posts")
	private var _REF_USERS = DB_BASE.child("users")
	
	// Storage References
	private var _REF_POST_IMAGES = STORAGE_BASE.child("feed-pics")
	
	var REF_BASE: FIRDatabaseReference {
		return _REF_BASE
	}
	
	var REF_POSTS: FIRDatabaseReference {
		return _REF_POSTS
	}
	
	var REF_USERS: FIRDatabaseReference {
		return _REF_USERS
	}
	
	var REF_POST_IMAGES: FIRStorageReference {
		return _REF_POST_IMAGES
	}

	var REF_USER_CURRENT: FIRDatabaseReference {
		let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
		let user = REF_USERS.child(uid!)
		return user
	}

	func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}
	
}






