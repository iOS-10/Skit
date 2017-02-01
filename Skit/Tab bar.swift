//
//  Tab bar.swift
//  Skit
//
//  Created by Abdurrahman on 2/1/17.
//  Copyright © 2017 AR Ehsan. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		var sizeThatFits = super.sizeThatFits(size)
		sizeThatFits.height = 50
		return sizeThatFits
	}
}

extension UITabBarController {
	open override func awakeFromNib() {
		super.awakeFromNib()
		self.tabBar.unselectedItemTintColor = UIColor(hex: "E7E7E7")
	}
}
