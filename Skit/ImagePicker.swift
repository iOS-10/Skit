//
//  ImagePicker.swift
//  Skit
//
//  Created by Abdurrahman on 2/3/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import Foundation
import UIKit

extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
			postImg.image = img
			imagePicked = true
		} else {
			print("Image wasn't selected!")
		}
		
		picker.dismiss(animated: true, completion: nil)
	}
}
